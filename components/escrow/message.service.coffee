'use strict'

angular.module 'remitano'
.factory 'Message', ($resource) ->
  $resource '/api/v1/messages/:trade_ref/:since_id', {},
    query:
      method: 'GET',
      isArray: false
