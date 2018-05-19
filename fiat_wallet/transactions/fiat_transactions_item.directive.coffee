'use strict'

angular.module 'remitano'
.directive "fiatTransactionsItem", ->
  restrict: "E"
  scope:
    fiatTransaction: "="
  templateUrl: "fiat_wallet/transactions/fiat_transactions_item.tmpl.html"
  replace: true
  controllerAs: "vm"
  bindToController: true
  controller: ($state, MobileApp, RAILS_ENV) ->
    vm = this
    vm.MobileApp = window.MobileApp
    vm.currency = RAILS_ENV.current_currency
    vm.tradeLink = ->
      if vm.fiatTransaction?.trade_ref && vm.fiatTransaction?.coin_currency == RAILS_ENV.coin_currency
        $state.href("root.trade", ref: vm.fiatTransaction.trade_ref)
      else if vm.fiatTransaction?.coin_currency
        domain = "remitano.com"
        domain = "#{vm.fiatTransaction.coin_currency}.remitano.com" if vm.fiatTransaction.coin_currency != "btc"
        "https://#{domain}#{$state.href("root.trade", ref: vm.fiatTransaction.trade_ref)}"

    return

