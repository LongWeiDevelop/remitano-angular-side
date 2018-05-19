'use strict'

angular.module 'remitano'
.directive 'coinCurrencyToUsd', (RAILS_ENV) ->
  restrict: 'E'
  templateUrl: 'components/coin_currency_to_usd/coin_currency_to_usd.tmpl.html'
  scope:
    coinCurrencyAmount: '='
  controllerAs: "vm"
  bindToController: true
  controller: ->
    vm = @
    vm.usdAmount = ->
      (vm.coinCurrencyAmount * RAILS_ENV.exchange_rates[RAILS_ENV.default_exchange]).floor(2)
    return
