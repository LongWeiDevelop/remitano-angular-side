'use strict'

angular.module 'remitano'
.directive "remittanceDeposit", ->
  restrict: "EA"
  scope:
    remittance: "<"
    onDepositStatusChanged: "&"
  controllerAs: "vm"
  bindToController: true
  templateUrl: "remittance/show/remittance_deposit/tmpl.html"
  controller: ($scope, RAILS_ENV, Remittance) ->
    vm = this
    init = ->
      $scope.$watch "vm.remittance.deposit_trade", (trade) ->
        vm.tradeWithRole = trade

      vm.tradeStatus = null
      $scope.$watch "vm.tradeWithRole.trade.status", (status) ->
        if vm.tradeStatus == null
          vm.tradeStatus = status
        else
          vm.tradeStatus = status
          vm.onDepositStatusChanged()
    init()
    return
