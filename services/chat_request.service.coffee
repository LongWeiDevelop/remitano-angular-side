'use strict'

angular.module 'remitano'
.factory 'ChatRequest', ($resource) ->
  $resource '/api/v1/chat_requests/:id/:action',
    id: '@id'
    action: '@action'
