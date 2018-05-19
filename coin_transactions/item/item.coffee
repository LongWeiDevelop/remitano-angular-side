'use strict'

angular.module 'remitano'
.directive "btcTransactionsItem", ->
  restrict: "E"
  scope:
    btcTransaction: "="
  templateUrl: "coin_transactions/item/item.tmpl.html"
  replace: true
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, $state, MobileApp) ->
    vm = this
    vm.MobileApp = window.MobileApp
    vm.tradeLink = ->
      if vm.btcTransaction?.trade_ref
        $state.href("root.trade", ref: vm.btcTransaction.trade_ref)
    return
