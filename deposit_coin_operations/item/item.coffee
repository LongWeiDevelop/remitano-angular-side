'use strict'

angular.module 'remitano'
.directive "depositCoinOperationItem", ->
  restrict: "E"
  scope:
    coinTransaction: "="
  templateUrl: "deposit_coin_operations/item/item.tmpl.html"
  replace: true
  bindToController: true
  controllerAs: "vm"
  controller: (MobileApp, $rootScope) ->
    vm = this
    vm.MobileApp = MobileApp
    vm.transactionLink = ->
      $rootScope.transactionLink(vm.coinTransaction.tx_hash)

    vm.shortTxId = ->
      return unless vm.coinTransaction.tx_hash
      vm.coinTransaction.tx_hash.substr(0, 6)
    return
