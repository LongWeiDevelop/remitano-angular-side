'use strict'

angular.module 'remitano'
  .factory 'CashDepositProofService', ($uibModal) ->
    request: (trade) ->
      uibModalInstance = $uibModal.open(
        templateUrl: 'trade/cash_deposit_proof/tmpl.html'
        controller: 'CashDepositProofController as vm'
        size: 'md'
        resolve:
          trade: -> trade
      )
