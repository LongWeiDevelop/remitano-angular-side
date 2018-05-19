'use strict'

angular.module 'remitano'
.directive 'tradeCoinWithdrawalStatus', ->
  restrict: "E"
  templateUrl: "trade/trade_coin_withdrawal_status/tmpl.html"
  scope:
    coinWithdrawal: "="
  controllerAs: "vm"
  bindToController: true
  controller: ->
