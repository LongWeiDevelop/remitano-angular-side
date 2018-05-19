'use strict'

angular.module 'remitano'
.directive "tradeItem", ->
  restrict: "EA"
  replace: true
  scope:
    index: "<"
    tradeWithRole: "="
  controllerAs: "vm"
  bindToController: true
  templateUrl: "dashboard/escrow/trades/trade_item.tmpl.html"
  controller: ->
    vm = this
    init = ->
      vm.odd = vm.index % 2 == 1
      vm.trade = vm.tradeWithRole.trade
      vm.role = vm.tradeWithRole.role

      vm.coin_amount = if vm.tradeWithRole.role == "buyer"
        vm.trade.buyer_receiving_coin_amount
      else
        vm.trade.seller_sending_coin_amount

      vm.partner = if vm.tradeWithRole.role == "buyer"
        vm.trade.seller_username
      else
        vm.trade.buyer_username

    init()
    return
