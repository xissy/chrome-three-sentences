hasFrameset = (document_root) ->
  document_root.getElementsByTagName('frameset').length > 0


chrome.extension.sendMessage
  action: 'hasFrameset'
  result: hasFrameset document
