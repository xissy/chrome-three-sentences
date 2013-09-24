tabMap = {}

chrome.extension.onMessage.addListener (request, sender, sendResponse) ->
  switch request.action
    when 'htmlInjected'
      tabId = sender.tab.id
      tabMap[tabId] = []  if not tabMap[tabId]?
      tabMap[tabId].push request.html

    when 'getHtmlArray'
      sendResponse
        htmlArray: tabMap[request.tabId]


chrome.tabs.onRemoved.addListener (tabId, removeInfo) ->
  delete tabMap.tabId
