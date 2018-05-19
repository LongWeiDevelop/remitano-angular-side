'use strict'

angular.module 'remitano'
.directive 'tradeDepositInstruction', ->
  restrict: "E"
  templateUrl: "trade/trade_deposit_instruction/tmpl.html"
  scope:
    tradeWithRole: "="
  controllerAs: "vm"
  bindToController: true
  controller: ($state, RAILS_ENV) ->
    vm = this
    vm.trade = vm.tradeWithRole.trade
    vm.translateValues =
      coin_amount: "#{vm.trade.seller_sending_coin_amount_with_deposit_fee} #{RAILS_ENV.COIN_CURRENCY}"
      buyer_username: vm.trade.buyer_username
    vm.deposit_coin_amount = vm.trade.coin_amount

    return
