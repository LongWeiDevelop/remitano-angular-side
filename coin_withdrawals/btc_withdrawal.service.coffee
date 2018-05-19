'use strict'

angular.module 'remitano'
.factory 'CoinWithdrawal', ($resource) ->
  $resource '/api/v1/coin_withdrawals/:id/:controller',
    id: '@id'
  ,
    cancel:
      method: 'POST'
      params:
        controller: 'cancel'
    query:
      method:'GET'
      isArray: false
