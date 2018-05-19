'use strict'

angular.module 'remitano'
.factory 'CoinAccount', ($resource) ->
  $resource '/api/v1/coin_accounts/:id/:controller',
    id: '@id'
  ,
    me:
      method: 'GET'
      params:
        controller: 'me'
    newDepositAddress:
      method: 'POST'
      params:
        controller: 'new_deposit_address'
    pendingDeposit:
      method: 'GET'
      params:
        controller: 'pending_deposit'
