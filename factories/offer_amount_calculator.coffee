'use strict'
angular.module 'remitano'
  .factory 'OfferAmountCalculator', (AccountManager) ->
    class OfferAmountCalculator
      constructor: ({requested_coin_amount} = {}) ->
        @requested_coin_amount  = requested_coin_amount
    OfferAmountCalculator
