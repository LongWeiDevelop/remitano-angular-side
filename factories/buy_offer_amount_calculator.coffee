'use strict'
angular.module 'remitano'
  .factory 'BuyOfferAmountCalculator', ($stateParams, OfferAmountCalculator, RAILS_ENV) ->
    class BuyOfferAmountCalculator extends OfferAmountCalculator
      buyer_receiving_coin_amount: ->
        @requested_coin_amount * (1 - RAILS_ENV.trading_fee)

      seller_sending_coin_amount: ->
        @requested_coin_amount

    BuyOfferAmountCalculator
