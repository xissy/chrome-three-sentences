# Services
threeSentencesServices = angular.module 'threeSentencesServices', [ 'ng', 'ngResource' ]

# App
threeSentencesApp = angular.module 'threeSentencesApp', [ 'threeSentencesServices' ]

# Controllers

### SummaryController ###
#### Flow
#   1. hasFrameset?
#     * if true, pick the biggest frame and get the html.
#     * if false, get the entire html.
#   1. call the summary API with the html.
#   1. render the result from API.

threeSentencesApp.controller 'SummaryController', [
  '$scope'
  '$http'
  ($scope, $http) ->
    # get summarized sentences by API call.
    summarize = (sourceHtml, callback) ->
      $.post 'http://api.3s.recom.io:20030/v1/summary',
        sourceHtml: sourceHtml
      ,
        (response) ->
          callback null, response.summarizedSentences
      ,
        'json'


    # started by checking whether it has a frameset(s) or not.
    chrome.tabs.executeScript null,
      file: '/dist/scripts/hasFrameset.js'


    $scope.isLoading = true

    # chrome extension message handler.
    chrome.extension.onMessage.addListener (request, sender) ->
      switch request.action
        when 'getSource'
          summarize request.source, (err, summarizedSentences) ->
            $scope.$apply ->
              $scope.title = sender.tab.title
              $scope.summarizedSentences = summarizedSentences
              $scope.isLoading = false

        when 'hasFrameset'
          hasFrameset = request.result
          
          if hasFrameset
            chrome.extension.sendMessage
              action: 'getHtmlArray'
              tabId: sender.tab.id
            ,
              (response) ->
                htmlArray = response.htmlArray
                htmlArray.sort (a, b) -> b.length - a.length

                summarize htmlArray[0], (err, summarizedSentences) ->
                  $scope.$apply ->
                    $scope.title = sender.tab.title
                    $scope.summarizedSentences = summarizedSentences
                    $scope.isLoading = false
          else
            chrome.tabs.executeScript null,
              file: '/dist/scripts/getPagesSource.js'

]


# bootstrapping
angular.bootstrap document, [ 'threeSentencesApp' ]
