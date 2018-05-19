'use strict'

angular.module 'remitano'
.directive 'currentSellRate', (RatesManager, RAILS_ENV) ->
  restrict: 'E'
  templateUrl: 'components/btc_rates/current_sell_rate.tmpl.html'
  controllerAs: "vdm"
  controller: () ->
    vdm = @
    init = ->
      vdm.btcRates = -> RatesManager.currentBtcRates()

    init()
    return
