'use strict'

angular.module 'remitano'
.factory 'ActionConfirmation', ($resource) ->
  $resource '/api/v1/action_confirmations/:id/:action',
    id: '@id'
  ,
    confirm:
      method: "POST"
      params:
        action: "confirm"
    cancel:
      method: "POST"
      params:
        action: "cancel"
