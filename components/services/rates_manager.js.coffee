'use strict'

angular.module 'remitano'
.factory 'RatesManager', (BtcRates, $ngRedux, RAILS_ENV) ->
  _currentBtcRates: null
  _currentExchangeRates: null

  currentBtcRates: ->
    @_currentBtcRates ||= if $.jStorage.get('btcRates')
      new BtcRates($.jStorage.get('btcRates'))

  fetchBtcRates: ->
    BtcRates.fetch {}
    , (btcRates) =>
      @assignBtcRates(btcRates)

  assignBtcRates: (btcRates) ->
    $.jStorage.set 'btcRates', btcRates
    @_currentBtcRates = null

  currentExchangeRates: ->
    @_currentExchangeRates ||= if $.jStorage.get('exchangeRates')
      $.jStorage.get('exchangeRates')

  fetchExchangeRates: ->
    BtcRates.fetchExchange {}
    , (exchangeRates) =>
      @assignExchangeRates(exchangeRates)

  assignExchangeRates: (exchangeRates) ->
    #Hack to inject default exchange rate to redux store
    if exchangeRates
      $ngRedux.dispatch
        type: 'remitano/Shared/OfferPrice/SET_DEFAULT_EXCHANGE_RATE'
        payload: exchangeRates[RAILS_ENV.default_exchange]
      $ngRedux.dispatch
        type: 'remitano/Shared/OfferPrice/SET_EXCHANGE_RATES'
        payload: exchangeRates
    $.jStorage.set 'exchangeRates', exchangeRates
    @_currentExchangeRates = null
