'use strict'

angular.module 'remitano'
  .factory 'OfferPaymentMethodCache', (OfferPaymentMethod, $q) ->
    class OfferPaymentMethodCache
      @lookup: {}
      @singleton: (countryCode, offerType) ->
        @lookup[[countryCode, offerType].join("-")] ||= new OfferPaymentMethodCache(countryCode, offerType)
      constructor: (countryCode, offerType) ->
        @countryCode = countryCode
        @offerType = offerType

      fetch: ->
        $q (resolve, reject) =>
          if @methods?
            resolve(@methods)
          else
            @load().then(resolve, reject)

      load: ->
        @loadingPromise ||= $q (resolve, reject) =>
          success = (methods) =>
            delete @loadingPromise
            @methods = methods
            resolve(methods)

          OfferPaymentMethod.query(country_code: @countryCode, offer_type: @offerType).$promise.then(success, reject)
