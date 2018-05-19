'use strict'

angular.module 'remitano'
.factory 'AccountManager', (CoinAccount, FiatAccount, Auth, RAILS_ENV, $stateParams, $rootScope) ->
  _currentCoinAccount: null
  _currentRemiAccount: null
  _currentFiatAccount: null

  coinAddressChannel: ->
    if channel = $.jStorage.get("coinAddressChannel")
      @_coinAddressChannel ||= channel
    @_coinAddressChannel

  currentFiatAccount: ->
    if json = $.jStorage.get(@currentFiatAccountKey())
      @_currentFiatAccount ||= new FiatAccount(json)
    @_currentFiatAccount

  currentCoinAccount: ->
    if json = $.jStorage.get("coinAccount")
      @_currentCoinAccount ||= new CoinAccount(json)
    @_currentCoinAccount ||= {}

  depositCoinAccount: ->
    if json = $.jStorage.get("depositCoinAccount")
      @_depositCoinAccount ||= new CoinAccount(json)
    @_depositCoinAccount ||= {}

  fetchCoinAccounts: ->
    CoinAccount.me { coin_currency: RAILS_ENV.coin_currency }
    , (coinAccounts) =>
      @assignNewCoinAccount(coinAccounts)

  requestFiatAccount: ->
    FiatAccount.register({country_code: RAILS_ENV.current_country}, (fiatAccount) =>
      @assignNewFiatAccount(fiatAccount)
    ).$promise

  fetchFiatAccount: ->
    FiatAccount.me {country_code: RAILS_ENV.current_country}
    , (fiatAccount) =>
      @assignNewFiatAccount(fiatAccount)

  fetchFiatAccountIfApplicable: ->
    if Auth.hasFiatWallet()
      @fetchFiatAccount()
    else
      $.jStorage.deleteKey(@currentFiatAccountKey())
      delete @_currentFiatAccount

  assignNewCoinAccount: (coinAccounts) ->
    if Auth.isLoggedIn()
      $.jStorage.set "coinAccount", coinAccounts.main
      $.jStorage.set "btcAccount", coinAccounts.main
      $.jStorage.set "depositCoinAccount", coinAccounts.deposit
      $.jStorage.set "coinAddressChannel", coinAccounts.coin_address_channel
      @_currentCoinAccount = angular.extend(@_currentCoinAccount || {}, coinAccounts.main)
      @_depositCoinAccount = angular.extend(@_depositCoinAccount || {}, coinAccounts.deposit)
      @_coinAddressChannel = coinAccounts.coin_address_channel
      $rootScope.$broadcast('coinAccount:updated')

  currentFiatAccountKey: ->
    "fiat_account_#{$stateParams.country}"

  assignNewFiatAccount: (fiatAccount) ->
    if Auth.isLoggedIn()
      $.jStorage.set @currentFiatAccountKey(), fiatAccount
      if fiatAccount?
        @_currentFiatAccount = angular.extend(@_currentFiatAccount || {}, fiatAccount)
