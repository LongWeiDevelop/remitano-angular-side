'use strict'

angular.module 'remitano'
.directive 'tradeBuyerAlert', ->
  restrict: "E"
  templateUrl: "trade/trade_buyer_alert/tmpl.html"
  scope:
    tradeWithRole: "<"
    isRemittance: "<"
  controllerAs: "vm"
  bindToController: true
  controller: ($scope) ->
    vm = this
    vm.customPrefix = if vm.isRemittance then "remittance_" else ""
    $scope.$watch "vm.tradeWithRole.trade", (trade) ->
      vm.trade = trade
    return
