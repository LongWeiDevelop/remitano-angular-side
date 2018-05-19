'use strict'

angular.module('remitano').controller 'QuickTradeController',
(Offer, Trade, RatesManager, Auth, TradePreparator, Flash, PriceReloader, RAILS_ENV,
$scope, $filter, $rootScope, $analytics, $stateParams, $translate, mode) ->
  vm = this
  init = ->
    vm.mode = mode
    vm.offerType = if vm.mode == 'buy' then 'sell' else 'buy'
    vm.defaultCurrency = RAILS_ENV.country_currencies[$stateParams.country]
    vm.offers = []
    vm.targetOffer = null
    vm.retryAfter = 1000
    vm.formattedAmount = formattedAmount
    vm.openTrade = openTrade
    vm.hasAmount = hasAmount
    vm.findingCount = 0
    vm.offerClass = offerClass
    vm.setTradingOffer = setTradingOffer
    $scope.$watch "vm.amount", (amount) -> findTargetOffers(amount)
    $scope.$watch "vm.targetOffer", (targetOffer) ->
      vm.currency = targetOffer?.currency || vm.defaultCurrency

  hasAmount = ->
    return unless vm.amount?
    vm.amount > 0

  formattedAmount = ->
    return unless hasAmount()
    "#{vm.amount} #{RAILS_ENV.COIN_CURRENCY}"

  offerClass = (offer) ->
    ["offer", offer.payment_method, offer.bank_name].join("-")

  setTradingOffer = (offer) ->
    vm.tradingOffer = offer

  untrackOffersPrice = ->
    return unless vm.targetOffers?
    PriceReloader.removeOffer(offer) for offer in vm.targetOffers

  trackOffersPrice = ->
    return unless vm.targetOffers?
    PriceReloader.addOffer(offer) for offer in vm.targetOffers

  findTargetOffers = (amount) ->
    untrackOffersPrice()
    vm.targetOffers = []
    return unless hasAmount()
    findSuccess = (offers) ->
      if amount == vm.amount
        vm.targetOffers = offers
        trackOffersPrice()

    vm.findingCount += 1
    condition =
      coin_currency: RAILS_ENV.coin_currency
      country_code: $stateParams.country
      offer_type: vm.offerType
      coin_amount: amount

    Offer.best(condition).$promise.then(findSuccess).finally -> vm.findingCount -= 1

  openTrade = (form) ->
    return if form.$invalid || vm.submitting
    vm.tradingOffer ||= vm.targetOffers[0]
    return unless vm.tradingOffer?

    vm.submitted = true
    vm.submitting = true

    trade =
      offer_type: vm.offerType

    trade.coin_withdrawal_address = vm.coin_withdrawal_address
    trade.coin_amount = vm.amount

    TradePreparator.prepare(trade, vm.tradingOffer)

  init()
  return
