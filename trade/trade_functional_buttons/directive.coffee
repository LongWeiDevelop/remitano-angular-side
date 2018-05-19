'use strict'

angular.module 'remitano'
.directive "tradeFunctionalButtons", () ->
  restrict: "E"
  templateUrl: "trade/trade_functional_buttons/tmpl.html"
  scope:
    tradeWithRole: "="
    isRemittance: "<"
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, $state, dialogs, $translate, $window, Trade, CashDepositProofService, $uibModal) ->
    vm = this
    init = ->
      vm.cancelTrade = cancelTrade
      vm.releaseTrade = releaseTrade
      vm.markAsPaid = markAsPaid
      vm.disputeTrade = disputeTrade
      vm.reopenTrade = reopenTrade
      vm.statusIn = statusIn
      vm.payViaPoli = payViaPoli
      vm.isPoliPayment = isPoliPayment
      vm.tradeProcessing = false
      vm.customPrefix = if vm.isRemittance then "remittance_" else ""
      vm.canRelease = canRelease
      $scope.$watch "vm.tradeWithRole.trade", (trade) -> vm.trade = trade
      $scope.$watch "vm.tradeWithRole.payment_method", (payment_method) ->
        vm.centralized = (payment_method == 'fiat_deposit')
      $scope.$watch "vm.tradeWithRole.role", (role) -> vm.role = role

    payViaPoli = ->
      dialog = dialogs.confirm($translate.instant("other_confirmation"), $translate.instant("trade_confirm_poli_payment"))
      dialog.result.then (btn) ->
        vm.tradeProcessing = true
        Trade.payViaPoli(ref: vm.trade.ref, payViaPoliSuccess, changeStatusError)

    payViaPoliSuccess = (res) ->
      $window.location.href = res.trade.poli_payment_url

    isPoliPayment = ->
      vm.trade.offer_data.payment_method == "poli_payment"

    statusIn = (array) ->
      _.includes(array, vm.trade.status)

    changeStatusError= (res) ->
      vm.tradeProcessing = false
      dialogs.error($translate.instant("DIALOGS_ERROR"), res.data?.error || $translate.instant("other_internal_server_error"))

    requestChangeStatusSuccess = (res) ->
      vm.tradeProcessing = false
      if res.is_action_confirmation
        $state.go("root.actionConfirmationConfirm", id: res.id)
      else
        vm.tradeWithRole = res

    canRelease = ->
      return false if vm.tradeWithRole.use_fiat_deposit
      return true if vm.statusIn(['unpaid', 'paid', 'disputed'])
      if vm.trade.status == "unpaid"
        return true if vm.trade.offer_data?.offer_type == "sell"
      false

    cancelTrade = ->
      if vm.trade.status == "awaiting"
        abortTrade()
      else
        dialog = dialogs.confirm($translate.instant("other_confirmation"), $translate.instant("#{vm.customPrefix}trade_confirm_cancel"))
        dialog.result.then (btn) ->
          vm.tradeProcessing = true
          reallyCancelTrade()

    abortTrade = ->
      if vm.role == "buyer"
        reallyCancelTrade()
      else
        dialog = dialogs.confirm($translate.instant("other_confirmation"), $translate.instant("trade_confirm_seller_abort"))
        dialog.result.then (btn) ->
          vm.tradeProcessing = true
          reallyCancelTrade()


    reallyCancelTrade = ->
      Trade.cancel(ref: vm.trade.ref, requestChangeStatusSuccess, changeStatusError)

    markAsPaid = ->
      dialog = dialogs.confirm($translate.instant("other_confirmation"), $translate.instant("#{vm.customPrefix}trade_confirm_paid"))
      dialog.result.then(askForProof).then (proofUrl) ->
        vm.tradeProcessing = true
        params =
          ref: vm.trade.ref
          payment_receipt_details:
            proof_url: proofUrl
        Trade.markAsPaid(params, requestChangeStatusSuccess, changeStatusError)

    reopenTrade = ->
      vm.tradeProcessing = true
      Trade.reopen({ ref: vm.trade.ref }, requestChangeStatusSuccess, changeStatusError)

    releaseTrade = ->
      dialog = dialogs.confirm($translate.instant("other_confirmation"), $translate.instant("#{vm.customPrefix}trade_confirm_release"))
      dialog.result.then ->
        vm.tradeProcessing = true
        Trade.release(ref: vm.trade.ref, requestChangeStatusSuccess, changeStatusError)

    askForProof = ->
      if vm.trade.offer_data.payment_method == "cash_deposit"
        CashDepositProofService.request(vm.trade).result

    disputeTrade = ->
      dialog = dialogs.confirm($translate.instant("other_confirmation"), $translate.instant("#{vm.customPrefix}trade_confirm_dispute_as_#{vm.role}"))
      dialog.result.then (btn) ->
        vm.tradeProcessing = true
        Trade.dispute(ref: vm.trade.ref, requestChangeStatusSuccess, changeStatusError)

    init()
    return
