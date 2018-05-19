'use strict'

angular.module 'remitano'
.directive "tradeFiatWithdrawalDetails", ->
  restrict: "E"
  templateUrl: "trade/trade_fiat_withdrawal_details/tmpl.html"
  scope:
    tradeWithRole: "="
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, ObjectLiveUpdater, RAILS_ENV) ->
    vm = @
    init = ->
      vm.fiatWithdrawalStatusClass = fiatWithdrawalStatusClass
      vm.manualPayment = RAILS_ENV.fiat_payment_method?.manual
      $scope.$watch "vm.tradeWithRole.trade", (trade) ->
        vm.trade = trade
        vm.fiatWithdrawalDetails = vm.tradeWithRole.fiat_withdrawal_details
        ObjectLiveUpdater.singleton("fiat_withdrawal").add(vm.fiatWithdrawalDetails)
        vm.currency = vm.trade.offer_data.currency
        vm.isVisible = vm.trade.status == "released"

    fiatWithdrawalStatusClass = (status) ->
      switch status
        when "delivered" then "badge-success"
        when "cancelled" then ""
        when "error" then "badge-danger"
        else "badge-warning"

    init()
    return
