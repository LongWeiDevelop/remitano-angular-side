'use strict'

angular.module 'remitano'
.directive "offerFormOfferDetails", ($translate) ->
  restrict: "E"
  scope: false
  templateUrl: "offer_form/offer_details/offer_details.tmpl.html"
  controllerAs: 'offer_subvm'
  controller: (RAILS_ENV, CURRENCY_PRECISION, $translate, $scope, RatesManager, $filter) ->
    offer_subvm = @
    init = ->
      offer_subvm.show_min_amount_form = false
      offer_subvm.show_max_amount_form = false
      offer_subvm.show_offer_currency_form = false
      offer_subvm.show_offer_price_form = false
      offer_subvm.availableCurrencies = RAILS_ENV.currencies
      offer_subvm.availableTypes = availableTypes
      offer_subvm.maxOfMinAmount = ->
        Math.min(parseFloat($scope.vm.offer.max_amount, 10), COIN_CURRENCY_CONFIG.min_trade_amounts[RAILS_ENV.coin_currency] * 10000)
      offer_subvm.minBtcPrice = minBtcPrice
      offer_subvm.maxBtcPrice = maxBtcPrice
      offer_subvm.minBtcPriceStr = minBtcPriceStr
      offer_subvm.maxBtcPriceStr = maxBtcPriceStr
      offer_subvm.maxDecimals = CURRENCY_PRECISION[$scope.vm.offer.currency]
      offer_subvm.maxDecimalsForPrice = offer_subvm.maxDecimals + 2
      offer_subvm.isValidBtcMinPrice = isValidBtcMinPrice
      offer_subvm.isValidBtcMaxPrice = isValidBtcMaxPrice

    availableTypes = _.map(RAILS_ENV.offer_types, (type) ->
      {value: type, name: $translate.instant("offer_#{type}")}
    )

    minBtcPrice = ->
      if (price = averagePrice())
        price * 0.5

    maxBtcPrice = ->
      if (price = averagePrice())
        price * 2

    minBtcPriceStr = ->
      $filter('priceFormatter')(minBtcPrice(), $scope.vm.offer.currency)

    maxBtcPriceStr = ->
      $filter('priceFormatter')(maxBtcPrice(), $scope.vm.offer.currency)

    isValidBtcMinPrice = (value) ->
      return true if _.isNil(value)
      return true if value == 0
      value >= minBtcPrice()

    isValidBtcMaxPrice = (value) ->
      return true if _.isNil(value)
      value <= maxBtcPrice()

    averagePrice = ->
      currency = $scope.vm.offer.currency
      price = RAILS_ENV.currency_rates[currency]
      return unless price?
      price * RatesManager.currentExchangeRates()[$scope.vm.offer.reference_exchange]

    init()
    return
