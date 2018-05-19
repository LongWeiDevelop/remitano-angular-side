'use strict'
angular.module 'remitano'
  .factory 'SellOfferAmountCalculator', ($stateParams, OfferAmountCalculator, RAILS_ENV) ->
    class SellOfferAmountCalculator extends OfferAmountCalculator
      buyer_receiving_coin_amount: ->
        @requested_coin_amount

      seller_sending_coin_amount: ->
        @requested_coin_amount * (1 + RAILS_ENV.trading_fee)

    SellOfferAmountCalculator
