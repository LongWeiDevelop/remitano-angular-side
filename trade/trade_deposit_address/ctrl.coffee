'use strict'

angular.module 'remitano'
.directive 'tradeDepositAddress', ->
  restrict: "E"
  templateUrl: "trade/trade_deposit_address/tmpl.html"
  scope:
    tradeWithRole: "="
  controllerAs: "vm"
  bindToController: true
  controller: ->
    vm = @
    init = ->
      vm.address = -> vm.tradeWithRole?.coin_deposit_address

    init()
    return
