'use strict'

angular.module 'remitano'
.factory 'FiatWithdrawal', ($resource) ->
  $resource '/api/v1/fiat_withdrawals/:id/:action',
    id: '@id'
  ,
    cancel:
      method: 'POST'
      params:
        action: 'cancel'
    query:
      method: 'GET'
      isArray: false
