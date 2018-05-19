'use strict'

angular.module 'remitano'
.directive 'currentBuyRate', (AccountManager, RatesManager, RAILS_ENV) ->
  restrict: 'E'
  templateUrl: 'components/btc_rates/current_buy_rate.tmpl.html'
  controllerAs: "vdm"
  controller: () ->
    vdm = @
    init = ->
      vdm.btcAccount = -> AccountManager.currentCoinAccount()
      vdm.btcRates = -> RatesManager.currentBtcRates()
      vdm.minimumDeposit = RAILS_ENV.minimum_deposit

    init()
    return
