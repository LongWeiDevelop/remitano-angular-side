'use strict'

angular.module 'remitano'
.directive 'tradeSellerPerspective', ->
  restrict: "E"
  templateUrl: "trade/trade_seller_perspective/tmpl.html"
  scope:
    tradeWithRole: "="
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, AccountManager) ->
    vm = this
    init = ->
      vm.statusIn = statusIn
      vm.hidePaymentInformation = hidePaymentInformation
      vm.tradeIcon = tradeIcon
      vm.tradePhase = tradePhase
      vm.currency = vm.tradeWithRole.trade.currency
      $scope.$watch "vm.tradeWithRole.trade", (trade) ->
        vm.trade = trade
      $scope.$watch "vm.tradeWithRole.centralized", (centralized) ->
        vm.centralized = centralized

      vm.hasAvailableBalance = hasAvailableBalance

    hasAvailableBalance = ->
      AccountManager.currentCoinAccount().available_balance > 0.02

    statusIn = (array) ->
      _.includes(array, vm.trade?.status)

    tradeIcon = ->
      switch vm.trade?.status
        when "awaiting" then "icon-hourglass"
        when "cancelled", "cancelled_automatically", "aborted" then "icon-cancel"
        when "released" then "icon-ok"
        when "unpaid", "paid", "disputed" then "icon-lock"

    tradePhase = ->
      return "cancelled" if statusIn(["cancelled", "cancelled_automatically", "aborted"])
      switch vm.trade?.status
        when "awaiting" then "awaiting"
        when "released" then "released"
        when "unpaid", "paid", "disputed" then "locked"

    hidePaymentInformation = ->
      statusIn(['cancelled', 'cancelled_automatically', 'released'])

    init()
    return
