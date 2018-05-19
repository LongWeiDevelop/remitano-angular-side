'use strict'

angular.module 'remitano'
.directive 'coinAddress', (AccountManager, RatesManager, RAILS_ENV) ->
  restrict: 'E'
  templateUrl: 'coin_wallet/deposit/coin_address.tmpl.html'
  scope:
    address: "="
  controllerAs: "vm"
  bindToController: true
  controller: ($scope) ->
    vm = @
    init = ->
      vm.coinAccount = -> AccountManager.depositCoinAccount()
      vm.depositFee = RAILS_ENV.deposit_fees[RAILS_ENV.coin_currency]
      vm.coinProtocol = "#{RAILS_ENV.coin_currency_name.toLowerCase()}:"

    init()
    return
