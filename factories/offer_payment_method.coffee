'use strict'

angular.module 'remitano'
.factory 'OfferPaymentMethod', ($resource) ->
  $resource '/api/v1/offer_payment_methods/:action',
    action: "@action"
