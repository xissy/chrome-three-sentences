getText = ->
  document.body.innerText

getHtml = ->
  document.body.outerHTML


chrome.extension.sendMessage
  action: 'htmlInjected'
  html: getHtml()
  