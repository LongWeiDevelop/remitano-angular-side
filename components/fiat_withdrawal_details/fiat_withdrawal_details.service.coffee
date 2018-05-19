'use strict'

angular.module 'remitano'
.factory 'FiatWithdrawalDetails', ($resource) ->
  $resource '/api/v1/fiat_withdrawal_details/:id/:action',
    id: '@id'
