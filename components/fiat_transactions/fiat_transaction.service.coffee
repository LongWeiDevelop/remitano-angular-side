'use strict'

angular.module 'remitano'
.factory 'FiatTransaction', ($resource) ->
  $resource '/api/v1/fiat_transactions/:id/:action',
    id: '@id'
  ,

