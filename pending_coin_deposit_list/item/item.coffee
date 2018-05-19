'use strict'

angular.module 'remitano'
.directive "pendingCoinDepositItem", ->
  restrict: "E"
  scope:
    txHash: "="
    amount: "="
  templateUrl: "pending_coin_deposit_list/item/item.tmpl.html"
  replace: true
  bindToController: true
  controllerAs: "vm"
  controller: (MobileApp, RAILS_ENV, COIN_CURRENCY_CONFIG) ->
    vm = this
    vm.MobileApp = MobileApp
    vm.transactionLink = ->
      COIN_CURRENCY_CONFIG.transaction_links[RAILS_ENV.coin_currency] + vm.txHash

    vm.shortTxId = ->
      return unless vm.txHash
      vm.txHash.substr(0, 6)

    return
