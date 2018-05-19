'use strict'

angular.module 'remitano'
.factory 'TrustedDevice', ($resource) ->
  $resource '/api/v1/trusted_devices/:id/:action',
    id: '@id'
  ,
    query:
      method: "GET"
      isArray: false
    delete:
      method: "DELETE"
