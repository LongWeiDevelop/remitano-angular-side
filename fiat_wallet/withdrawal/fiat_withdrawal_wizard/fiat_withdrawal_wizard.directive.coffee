'use strict'

angular.module 'remitano'
.directive "fiatWithdrawalWizard", ->
  restrict: "E"
  templateUrl: "fiat_wallet/withdrawal/fiat_withdrawal_wizard/fiat_withdrawal_wizard.tmpl.html"
  controllerAs: "vm"
  bindToController: true
  scope: {}
  controller: ($state) ->
    vm = @

    init = ->
      vm.step = 0
      vm.fiatWithdrawal = {}
      vm.backToStep = backToStep
      vm.selectAccount = selectAccount
      vm.enterFiatAmount = enterFiatAmount

    selectAccount = (account) ->
      if account.status == 'unconfirmed'
        $state.go("root.actionConfirmationConfirm", id: account.action_confirmation_id)
      else
        vm.fiatWithdrawal.account = account
        vm.step = 1

    enterFiatAmount = (amount) ->
      vm.fiatWithdrawal.fiat_amount = amount
      vm.step = 2

    backToStep = (step) ->
      if vm.step >= step
        vm.step = step

    init()
    return
