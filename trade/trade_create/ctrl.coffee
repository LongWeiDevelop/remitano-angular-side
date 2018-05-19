'use strict'

angular.module 'remitano'
.controller 'TradeCreateController',
(Trade, Flash, $translate, $state, $analytics, TradePreparator, Auth, RAILS_ENV) ->
  vm = @
  init = ->
    vm.pendingTrade = TradePreparator.getTrade()
    if !vm.pendingTrade
      return $state.go("root.home")
    vm.pendingTradeOffer = TradePreparator.getOffer()
    if vm.pendingTrade && vm.pendingTradeOffer
      vm.pendingTrade.offer_id = vm.pendingTradeOffer.id

    vm.createTrade = createTrade

  createTrade = (paymentDetails) ->
    vm.creating = true
    vm.pendingTrade.payment_details = paymentDetails
    vm.pendingTrade.observing_prices =
      price: vm.pendingTradeOffer.price
      price_per_coin: vm.pendingTradeOffer.price_per_coin
      max_coin_price: vm.pendingTradeOffer.max_coin_price
      min_coin_price: vm.pendingTradeOffer.min_coin_price

    Trade.save(vm.pendingTrade, createTradeSuccess, createTradeError)

  createTradeSuccess = (res) ->
    TradePreparator.cleanUp()
    if res.is_action_confirmation
      $state.go("root.actionConfirmationConfirm", id: res.id)
    else
      $analytics.eventTrack('createTrade', {  category: 'trade', label: "Logged In #{vm.offerType}", value: res.coin_amount * 1000 })
      $state.go("root.trade", {ref: res.ref})

  createTradeError = (res) ->
    vm.creating = false
    Flash.addCache('danger', res.data?.error || $translate.instant("other_something_went_wrong"))
    TradePreparator.goBack()

  init()
  return
