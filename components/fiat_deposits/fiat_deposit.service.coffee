'use strict'

angular.module 'remitano'
.factory 'FiatDeposit', ($resource) ->
  $resource '/api/v1/fiat_deposits/:id/:action',
    id: '@id'
  ,
    query:
      method: 'GET'
      isArray: false

    currentFiatDeposit:
      method: 'GET'
      isArray: false
      params:
        id: 'current_fiat_deposit'

    cancelFiatDeposit:
      method: 'POST'
      isArray: false
      params:
        action: 'cancel'

    submitAppendix:
      method: 'POST'
      isArray: false
      params:
        action: 'appendix'
