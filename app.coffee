'use strict'

angular.module 'remitano', [
  'app.core',
  'app.widgets'
]

.config ($locationProvider) ->
  $locationProvider.html5Mode(true)

.config ($urlRouterProvider, RAILS_ENV) ->
  $urlRouterProvider.otherwise("/#{RAILS_ENV.current_country}")

.config ($translateProvider, RAILS_ENV) ->
  for country, locale of RAILS_ENV.country_locale
    $translateProvider
      .translations(locale, Locale["#{locale.replace("-", "_").toUpperCase()}_LOCALES"] || {})

  $translateProvider.fallbackLanguage("en")
  $translateProvider.preferredLanguage("en")
  $translateProvider.useSanitizeValueStrategy("sanitizeParameters")
  $translateProvider.usePostCompiling(true)
.run ($translate, i18n, moment) ->
  moment.locale i18n.locale()
  $translate.use i18n.locale()

.config ($urlMatcherFactoryProvider) ->
  $urlMatcherFactoryProvider.strictMode(false)
  $urlMatcherFactoryProvider.type 'email',
    encode: angular.identity
    decode: angular.identity
    is: (item) ->
      /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(item)

.config (dialogsProvider) ->
  dialogsProvider.useBackdrop "static"
  dialogsProvider.useEscClose false
  dialogsProvider.useCopy false
  dialogsProvider.setSize "sm"

.config ($animateProvider) ->
  $animateProvider.classNameFilter(/^(?:(?!ng-animate-disabled).)*$/)

# whitelist bitcoin protocol for a's href (http://stackoverflow.com/questions/15606751/angular-changes-urls-to-unsafe-in-extension-page)
.config ($compileProvider) ->
  $compileProvider.aHrefSanitizationWhitelist /^\s*(https?|ftp|mailto|bitcoin|tel):/

.config ($sceDelegateProvider) ->
  $sceDelegateProvider.resourceUrlWhitelist [
    'self',
    'https://*.youtube.com/**'
    'https://youtube.com/**'
    'http://*.youku.com/'
  ]
.config ($translateProvider, RAILS_ENV) ->
  $translateProvider.useInterpolation('coinAwareInterpolation')
  if RAILS_ENV.env == "test"
    $translateProvider.useMissingTranslationHandler('alertMissingTranslationHandler')
    $translateProvider.postProcess('alertMissingTranslateValues')

.config ($intercomProvider, RAILS_ENV, USE_INTERCOM) ->
  if RAILS_ENV.env == "production"
    $intercomProvider.appID('e1lzm5au')
  else
    $intercomProvider.appID('c7w5yt9d')
  if (RAILS_ENV.env != "test") && USE_INTERCOM
    $intercomProvider.asyncLoading(true)

.config (cdnSrcConfigurationProvider, CDN_HOST) ->
  cdnSrcConfigurationProvider.setCdnServers [
    CDN_HOST
  ]
  return

.run (uuid) ->
  unless $.jStorage.get('device_uuid')
    $.jStorage.set('device_uuid', uuid.v4())

.run ($rootScope) ->
  window.addEventListener 'message', (event) ->
    switch event.data
      when 'oauthCompleted'
        $rootScope.$broadcast('oauthCompleted', {})
.run ($rootScope, RAILS_ENV, COIN_CURRENCY_CONFIG) ->
  $rootScope.coin_currency = RAILS_ENV.coin_currency
  $rootScope.COIN_CURRENCY = RAILS_ENV.coin_currency?.toUpperCase()
  $rootScope.coin_currency_name = RAILS_ENV.coin_currency_name
  $rootScope.ADDRESS_PATTERN = new RegExp(COIN_CURRENCY_CONFIG.address_patterns[RAILS_ENV.coin_currency])
  $rootScope.transactionLink = (tx_hash) ->
    COIN_CURRENCY_CONFIG.transaction_links[RAILS_ENV.coin_currency] + tx_hash

  $rootScope.addressLink = (address) ->
    COIN_CURRENCY_CONFIG.transaction_links[RAILS_ENV.coin_currency] + address

.run ($rootScope, $state, $stateParams, $translate, uibPaginationConfig, Flash, Intercom,
Auth, RAILS_ENV, USE_INTERCOM, AccountManager, RatesManager, $analytics, Configures, MobileApp) ->
  $rootScope.Flash = Flash
  RatesManager.assignBtcRates(RAILS_ENV.btc_rates)
  RatesManager.assignExchangeRates(RAILS_ENV.exchange_rates)
  Auth.initializeSettings()

  registerAnalytics = ->
    if Auth.isLoggedIn()
      $analytics.setUsername(Auth.currentUser()?.intercom_id)

  loadIntercom = ->
    return unless USE_INTERCOM
    userHash = {widget: activator: '#IntercomDefaultWidget'}
    if Auth.isLoggedIn()
      user = Auth.currentUser()
      angular.extend(userHash, userHash, {
        user_id:             user.intercom_id
        email:               user.email
        name:                user.intercom_id
        user_hash:           user.intercom_hash
        created_at:          user.created_at
        phone:               user.phone_number
        doc_status:          user.doc_status
        country_code:        user.country_code
        active_trades_count: user.active_trades_count
        partners_traded:     user.partners_traded
        trades_released:     user.trades_released
        last_active_trade:   user.last_active_trade
        two_factor_enabled:  user.two_factor_enabled
      })
      for coinCurrency in Object.keys(COIN_CURRENCY_CONFIG.coin_names)
        userHash["#{coinCurrency}_balanke"] = user["#{coinCurrency}_balanke"]
    Intercom.boot userHash

  reloadUser = ->
    if Auth.isLoggedIn()
      AccountManager.fetchCoinAccounts()
      AccountManager.fetchFiatAccountIfApplicable()
      Auth.reloadUser()
      .then ->
        if Auth.isLoggedIn()
          loadIntercom()
          registerAnalytics()
    else
      Auth.initializeSettings()
      loadIntercom()
    MobileApp.sendJstorage()

  processFlash = ->
    Flash.clear()
    Flash.popCache()

  $rootScope.$on '$stateChangeStart', (event, next) ->
    reloadUser()
    processFlash()

  $rootScope.$on 'userLoggedIn', (event, next) ->
    reloadUser()

  $rootScope.$on('$translateChangeSuccess', ->
    uibPaginationConfig.firstText = $translate.instant("ui_first_text")
    uibPaginationConfig.previousText = $translate.instant("ui_previous_text")
    uibPaginationConfig.nextText = $translate.instant("ui_next_text")
    uibPaginationConfig.lastText = $translate.instant("ui_last_text")
  )

  MobileApp.initListeners()
