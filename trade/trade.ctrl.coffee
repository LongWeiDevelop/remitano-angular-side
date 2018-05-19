'use strict'

angular.module 'remitano'
.controller 'TradeController',
(AccountManager, Auth, $rootScope, $filter, $location
  $scope, $stateParams, Trade, DynamicTitle, $translate, $analytics, dialogs) ->
  vm = @
  init = ->
    vm.currentUser = Auth.currentUser()
    vm.ref = $stateParams.ref
    vm.reloadTrade = reloadTrade
    vm.showPhone = $stateParams.lang == 'vi'
    vm.statusIn = statusIn
    vm.showPartnerSummary = showPartnerSummary
    DynamicTitle.setTranslated("#{$translate.instant('trade')} ##{vm.ref}")
    getTrade()
    notifyPoliPaymentStatus()

  showPartnerSummary = ->
    return false unless vm.trade?.partner
    return true if vm.currentUser.seeder
    !statusIn(['released', 'cancelled', 'cancelled_automatically', 'aborted'])

  notifyPoliPaymentStatus = ->
    status = $location.search().poli_status
    if status == "completed"
      dialogs.notify($translate.instant("DIALOGS_NOTIFICATION"), $translate.instant("trade_poli_payment_#{status}_status"))
    else if status == "cancelled" || status == "failed"
      dialogs.error($translate.instant("DIALOGS_ERROR"), $translate.instant("trade_poli_payment_#{status}_status"))

  statusIn = (array) ->
    return false unless vm.trade?.trade?
    _.includes(array, vm.trade.trade.status)

  getTradeSuccess = (data) ->
    if data.trade.coin_currency != $rootScope.coin_currency
      window.location.href = "https://#{Auth.domainFor(data.trade.coin_currency)}/#{$stateParams.country}/trades/#{vm.ref}"
      return
    vm.fetching = false
    vm.fetchError = false
    vm.trade = data
    if vm.trade.role == "seller"
      vm.way = "sell"
      vm.otherUser = vm.trade.trade.buyer_username
    else
      vm.way = "buy"
      vm.otherUser = vm.trade.trade.seller_username
    vm.fetchSuccess = true
    trade = new Trade
    data =
      ref: vm.ref
      category: 'trade'
      label: 'traded'
    $analytics.eventTrack('inTrade', data)

  getTradeError = ->
    vm.fetching = false
    vm.fetchError = true

  getTrade = ->
    vm.fetching = true
    vm.fetchError = false
    Trade.get({ref: vm.ref}, getTradeSuccess, getTradeError)

  reloadTrade = ->
    Auth.reloadUser()
    getTrade()

  init()
  return
