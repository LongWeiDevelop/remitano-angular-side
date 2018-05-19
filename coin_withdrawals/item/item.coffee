'use strict'

angular.module 'remitano'
.directive "coinWithdrawalsItem", ($translate, $timeout, $rootScope, CoinWithdrawal, $state) ->
  restrict: "E"
  scope:
    coinWithdrawal: "="
  templateUrl: "coin_withdrawals/item/item.tmpl.html"
  replace: true
  bindToController: true
  controllerAs: "vm"
  controller: ($rootScope) ->
    vm = this

    init = ->
      vm.transactionLink = transactionLink
      vm.shortTxId = shortTxId
      vm.shortBtcAddress = shortBtcAddress
      vm.btcAddressLink = btcAddressLink
      vm.cancelCoinWithdrawal = cancelCoinWithdrawal
      vm.confirmCoinWithdrawal = confirmCoinWithdrawal
      vm.withdrawalStatusClass = withdrawalStatusClass

    withdrawalStatusClass = (status) ->
      switch status
        when "processed", "approved" then "badge-success"
        when "unconfirmed", "pending", "scheduled" then "badge-warning"
        else "badge-danger"

    transactionLink = ->
      $rootScope.transactionLink(vm.coinWithdrawal.tx_hash)

    shortTxId = ->
      vm.coinWithdrawal.tx_hash.substr(0, 6)

    btcAddressLink = ->
      $rootScope.addressLink(vm.coinWithdrawal.address)

    shortBtcAddress = ->
      "#{vm.coinWithdrawal.coin_address.substr(0, 6)}..."

    cancelCoinWithdrawal = (e) ->
      e.preventDefault()
      CoinWithdrawal.cancel {id: vm.coinWithdrawal.id}, cancelSuccess, cancelError

    confirmCoinWithdrawal = (e) ->
      e.preventDefault()
      $state.go("root.actionConfirmationConfirm", id: vm.coinWithdrawal.action_confirmation?.id)

    cancelSuccess = (data) =>
      angular.extend(vm.coinWithdrawal, data)

    cancelError = (response) =>
      dialogs.error($translate.instant("other_error"),
        $translate.instant(response.data?.key) || $translate.instant("other_internal_server_error"))

    init()
    return
