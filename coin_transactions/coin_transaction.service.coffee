'use strict'

angular.module 'remitano'
.factory 'CoinTransaction', ($resource) ->
  $resource '/api/v1/coin_transactions/:id/:controller',
    id: '@id'
  ,

