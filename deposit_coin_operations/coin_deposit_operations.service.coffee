'use strict'

angular.module 'remitano'
.factory 'CoinDepositOperation', ($resource) ->
  $resource '/api/v1/coin_deposit_operations/:id/:controller',
    id: '@id'
  ,
    query:
      method: 'GET'
      isArray: false
