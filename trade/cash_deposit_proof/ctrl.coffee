'use strict'

angular.module 'remitano'
.controller 'CashDepositProofController', ($uibModalInstance, trade) ->
  vm = this
  init = ->
    vm.trade = trade
    vm.confirm = confirm

  confirm = ->
    $uibModalInstance.close(vm.proof_url)

  init()
  return

