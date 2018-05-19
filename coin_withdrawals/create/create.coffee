'use strict'

angular.module 'remitano'
.directive "coinWithdrawalsCreate", ($state, $stateParams, $translate, $rootScope, dialogs, Flash, CoinWithdrawal, RAILS_ENV, COIN_CURRENCY_CONFIG, AccountManager, RatesManager) ->
  restrict: "E"
  scope: {}
  templateUrl: "coin_withdrawals/create/create.tmpl.html"
  controller: ($scope) ->
    vm = this
    init = ->
      vm.coinAccount = -> AccountManager.currentCoinAccount()
      vm.coinWithdrawal = newCoinWithdrawal()
      vm.submitCoinWithdrawal = submitCoinWithdrawal
      vm.prepareToSubmitCoinWithdrawal = prepareToSubmitCoinWithdrawal
      vm.coinBalanceAmount = coinBalanceAmount
      vm.coinMinWithdrawalAmount = COIN_CURRENCY_CONFIG.min_withdrawals[$rootScope.coin_currency]
      vm.btcRates = RatesManager.currentBtcRates
      vm.btcWithdrawableBalance = btcWithdrawableBalance
      vm.maxPrecisions = COIN_CURRENCY_CONFIG.precision_digits[$rootScope.coin_currency]
      vm.pattern = $rootScope.ADDRESS_PATTERN

    newCoinWithdrawal = ->
      coin_currency: RAILS_ENV.coin_currency

    prepareToSubmitCoinWithdrawal = (form) ->
      if form.$valid
        vm.submitCoinWithdrawal(form)

    btcWithdrawableBalance = ->
      vm.coinAccount()?.available_withdrawable_balance
    coinBalanceAmount = ->
      vm.coinAccount()?.available_balance

    submitCoinWithdrawal = (form) ->
      form.submitting = true
      submitSuccess = (data) =>
        vm.coinWithdrawal = newCoinWithdrawal()
        form.submitting = false
        form.$submitted = false
        $state.go("root.actionConfirmationConfirm", id: data.id)

      submitError = (response) =>
        form.submitting = false
        dialogs.error($translate.instant("DIALOGS_ERROR"), response.data?.error || $translate.instant("other_internal_server_error"))

      CoinWithdrawal.save(coin_withdrawal: vm.coinWithdrawal, submitSuccess, submitError)

    init()
    return

  controllerAs: "vm"
