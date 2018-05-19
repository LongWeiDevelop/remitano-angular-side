'use strict'

angular.module 'remitano'
.factory 'PaymentOperation', ($resource) ->
  $resource '/api/v1/payment_operations/:id/:controller',
    id: '@id'
