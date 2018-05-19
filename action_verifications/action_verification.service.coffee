'use strict'

angular.module 'remitano'
.factory 'ActionVerification', ($resource) ->
  $resource '/api/v1/action_verifications/:id/:action',
    id: '@id'
  ,
    cancel:
      method: "POST"
      params:
        action: "cancel"
