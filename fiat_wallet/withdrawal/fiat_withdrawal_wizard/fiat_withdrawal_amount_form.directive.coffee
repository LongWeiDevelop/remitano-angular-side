'use strict'

angular.module 'remitano'
.directive "fiatWithdrawalAmountForm", ->
  restrict: "E"
  templateUrl: "fiat_wallet/withdrawal/fiat_withdrawal_wizard/fiat_withdrawal_amount_form.tmpl.html"
  controllerAs: "vm"
  scope:
    onFiatAmountEnterred: "&"
  bindToController: true
  controller: (AccountManager, RAILS_ENV, CURRENCY_PRECISION) ->
    vm = @

    init = ->
      vm.fiatAccount = -> AccountManager.currentFiatAccount()
      vm.currency = RAILS_ENV.current_currency
      vm.maxDecimals = CURRENCY_PRECISION[vm.currency]
      vm.minFiatAmount = RAILS_ENV.fiat_payment_method?.transaction_limit?.min
      vm.maxFiatAmount = RAILS_ENV.fiat_payment_method?.transaction_limit?.max
      vm.fiatBalance = fiatBalance
      vm.submitFiatAmount = submitFiatAmount
      vm.fee = RAILS_ENV.fiat_fee_structure?.ratio
      vm.min_fee = RAILS_ENV.fiat_fee_structure?.min

    fiatBalance = ->
      vm.fiatAccount()?.available_balance

    submitFiatAmount = (form) ->
      return unless form.$valid
      vm.onFiatAmountEnterred($amount: vm.fiat_amount)

    init()
    return

