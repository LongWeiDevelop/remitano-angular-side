'use strict'

angular.module 'remitano'
.factory 'Press', ($resource) ->
  $resource '/api/v1/presses/:action',
    action: '@action'
  ,
    details:
      method: 'GET'
      isArray: true
      params:
        action: 'details'

