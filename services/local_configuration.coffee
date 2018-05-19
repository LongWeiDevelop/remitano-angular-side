'use strict'

angular.module 'remitano'
.factory 'LocalConfiguration', ($rootScope) ->
  cached: {}
  set: (key, value) ->
    @cached[key] = value
    $.jStorage.set("local-configuration-#{key}", value)
    $rootScope.$broadcast("local-configuration-changed:#{key}")
  get: (key) ->
    @cached[key] ||= $.jStorage.get("local-configuration-#{key}")
