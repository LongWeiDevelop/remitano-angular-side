'use strict'

angular.module 'remitano'
.directive "remittanceWithdraw", ->
  restrict: "EA"
  scope:
    remittance: "<"
    onWithdrawStatusChanged: "&"
  controllerAs: "vm"
  bindToController: true
  templateUrl: "remittance/show/remittance_withdraw/tmpl.html"
  controller: ($scope, RAILS_ENV, Remittance) ->
    vm = this
    init = ->
      $scope.$watch "vm.remittance.withdraw_trade", (trade) ->
        vm.tradeWithRole = trade

      vm.tradeStatus = null
      $scope.$watch "vm.tradeWithRole.trade.status", (status) ->
        if vm.tradeStatus == null
          vm.tradeStatus = status
        else
          vm.tradeStatus = status
          vm.onWithdrawStatusChanged()
    init()
    return
