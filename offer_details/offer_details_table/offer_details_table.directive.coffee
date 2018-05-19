'use strict'

angular.module 'remitano'
.directive "offerDetailsTable", ->
  restrict: "E"
  templateUrl: "offer_details/offer_details_table/offer_details_table.tmpl.html"
  scope:
    offer: "="
  replace: true
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, $rootScope, RAILS_ENV, Auth, TradePreparator, PriceReloader, $translate, $filter,
  AccountManager, RatesManager, $state) ->
    vm = this
    init = ->
      vm.calculateOtherAmount = calculateOtherAmount
      vm.openTrade = openTrade
      vm.showForm = showForm
      vm.enoughBalance = enoughBalance
      vm.buying = vm.offer.offer_type == "sell"
      vm.buyOfferActive = buyOfferActive
      vm.amountError = false
      vm.submitting = false
      vm.isLoggedIn = Auth.isLoggedIn()
      vm.btcRate = getBtcRate
      vm.onDeleted = onDeleted
      vm.fee = RAILS_ENV.withdraw_fees[RAILS_ENV.coin_currency]
      vm.prefillAmount = prefillAmount
      $scope.$watch "vm.offer", (offer) ->
        PriceReloader.addOffer(offer) if offer?
        vm.isMyOffer = calculateIsMyOffer()
        prefillAmount()

      $scope.$watch "vm.offer.price_per_coin", calculateOtherAmount

    buyOfferActive = ->
      return true unless vm.offer.offer_type == "buy"
      !vm.offer.need_fiat_topup

    prefillAmount = (fill_type) ->
      return unless vm.offer?
      if fill_type == 'min'
        vm.amount = vm.offer.min_amount
      else if fill_type == 'max'
        vm.amount = vm.offer.max_amount
      else if vm.offer.offer_type == "buy"
        return unless (coinAccount = AccountManager.currentCoinAccount())?
        vm.amount = Math.min(coinAccount.available_balance, vm.offer.max_amount)
        vm.amount = Math.max(coinAccount.available_balance, vm.offer.min_amount)
      else
        vm.amount = vm.offer.min_amount
      calculateOtherAmount()

    getBtcRate = ->
      RatesManager.currentExchangeRates().bitstamp_BTCUSD

    calculateIsMyOffer = ->
      return false unless Auth.currentUser()
      vm.offer.username == Auth.currentUser().username

    enoughBalance = ->
      if vm.offer.offer_type == 'buy'
        true
      else
        vm.offer.min_amount <= vm.offer.max_amount

    showForm = ->
      !vm.isMyOffer && enoughBalance() && !vm.offer.blocked_by_current_user && buyOfferActive()

    amountWithFee = ->
      return 0 unless vm.amount?
      return 0 if vm.amount == ""

      if vm.buying
        amount = vm.amount + vm.fee
      else
        amount = vm.amount

    calculateOtherAmount = ->
      vm.amount = vm.amount.replace(",", ".") if typeof vm.amount == "string"
      vm.fiat_amount = amountWithFee() * vm.offer.price_per_coin
      validateAmount()

    validateAmount = ->
      if vm.amount > vm.offer.max_amount
        vm.amountError = "big"
      else if vm.amount < vm.offer.min_amount
        vm.amountError = "small"
      else
        vm.amountError = false

    onDeleted = ->
      $state.go("root.dashboard.escrow.offers")

    openTrade = (form) ->
      if form.$invalid || vm.submitting
        return

      vm.submitting = true

      trade =
        offer_id: vm.offer.id
        email: vm.email

      trade.coin_withdrawal_address = vm.coin_withdrawal_address
      trade.coin_amount = amountWithFee()

      TradePreparator.prepare(trade, vm.offer)

    init()
    return
