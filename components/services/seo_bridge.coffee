
'use strict'

angular.module("remitano").factory "SeoBridge", ($rootScope) ->
  factory =
    subscribe: (callback) ->
      $rootScope.$on("seo-data-changed", callback)
    publish: (data) ->
      $rootScope.$broadcast("seo-data-changed", data)
