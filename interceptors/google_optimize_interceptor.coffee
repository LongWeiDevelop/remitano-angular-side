'use strict'

optimizeActivate = ->
  window.dataLayer.push(event: 'optimize.activate')

angular.module 'remitano'
  .factory 'GoogleOptimizeInterceptor', ($timeout) ->
    response: (response) ->
      if window.dataLayer?
        $timeout optimizeActivate, 0, false
      response

  .config ($httpProvider) ->
    $httpProvider.interceptors.push('GoogleOptimizeInterceptor')
