'use strict'

angular.module 'remitano'
.factory 'Remittance', ($resource) ->
  $resource '/api/v1/remittances/:ref/:action',
    ref: "@ref"
  ,
    estimate:
      method:'POST'
      isArray: false
      params:
        action: "estimate"

    query:
      method:'GET'
      isArray: false

    depositMethods:
      method:'POST'
      isArray: true
      params:
        action: "deposit_methods"

    requestDeposit:
      method:'POST'
      params:
        action: "request_deposit"

    withdrawMethods:
      method:'POST'
      isArray: true
      params:
        action: "withdraw_methods"

    requestWithdraw:
      method:'POST'
      params:
        action: "request_withdraw"
