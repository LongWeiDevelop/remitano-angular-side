'use strict'

angular.module 'remitano'
.directive "tradeCoinWithdrawalAddress", ->
  restrict: "E"
  templateUrl: "trade/trade_coin_withdrawal_address/tmpl.html"
  scope:
    tradeWithRole: "="
  controllerAs: "vm"
  bindToController: true
  controller: ($scope) ->
    vm = @
    init = ->
      $scope.$watch "vm.tradeWithRole.trade", (trade) ->
        vm.trade = trade
        visibleStatus = ['unpaid', 'paid', 'disputed']
        vm.isVisible = _.includes(visibleStatus, vm.trade.status) && vm.tradeWithRole.coin_withdrawal_address?
        vm.isWarningVisible = vm.trade.status == "unpaid"

    init()
    return

