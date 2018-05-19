'use strict'

angular.module 'remitano'
.directive 'tradeBuyerPerspective', ->
  restrict: "E"
  templateUrl: "trade/trade_buyer_perspective/tmpl.html"
  scope:
    tradeWithRole: "="
  controllerAs: "vm"
  bindToController: true
  controller: ($scope) ->
    vm = this
    init = ->
      vm.statusIn = statusIn
      vm.hidePaymentInformation = hidePaymentInformation
      vm.tradeIcon = tradeIcon
      vm.tradePhase = tradePhase
      $scope.$watch "vm.tradeWithRole.trade", (trade) -> vm.trade = trade

    statusIn = (array) ->
      _.includes(array, vm.trade?.status)

    hidePaymentInformation = ->
      statusIn(['cancelled', 'cancelled_automatically', 'released', 'aborted'])

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

    init()
    return
