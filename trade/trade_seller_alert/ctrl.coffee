'use strict'

angular.module 'remitano'
.directive 'tradeSellerAlert', ->
  restrict: "E"
  templateUrl: "trade/trade_seller_alert/tmpl.html"
  scope:
    tradeWithRole: "<"
    isRemittance: "<"
  controllerAs: "vm"
  bindToController: true
  controller: ($scope) ->
    vm = this
    vm.customPrefix = if vm.isRemittance then "remittance_" else ""
    vm.showVcbMobileBankingWarning = ->
      return false unless _.includes(['unpaid', 'paid', 'disputed'], vm.trade?.status)
      vm.tradeWithRole?.payment_details?.bank_name == 'Vietcombank'

    $scope.$watch "vm.tradeWithRole.trade", (trade) ->
      vm.trade = trade

    return
