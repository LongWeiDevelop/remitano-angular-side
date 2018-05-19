'use strict'

angular.module 'remitano'
.factory 'FiatAccount', ($resource) ->
  $resource '/api/v1/fiat_accounts/:id/:action',
    id: '@id'
  ,
    me:
      method: 'GET'
      params:
        action: 'me'
    register:
      method: 'POST'
      params:
        action: 'register'
