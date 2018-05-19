'use strict'

angular.module 'remitano'
  .factory 'OfferCache', (Offer, PriceReloader, $q) ->
    class OfferCache
      @lookup: {}
      @singleton: (countryCode, offerType) ->
        @lookup[[countryCode, offerType].join("-")] ||= new OfferCache(countryCode, offerType)
      constructor: (countryCode, offerType) ->
        @countryCode = countryCode
        @offerType = offerType
        @offers = []
      findOffer: (condition) ->
        $q (resolve, reject) =>
          if (offer = @findInCache(condition))
            return resolve(offer)

          findSuccess = (offer) ->
            resolve(offer)

          findFailed = ->
            reject()

          @findUntilExhausted(condition).then(findSuccess, findFailed)

      findUntilExhausted: (condition) ->
        $q (resolve, reject) =>
          loadSuccess = (offers) =>
            if offers? && offers?.length
              if (offer = @findInArray(offers, condition))
                resolve(offer)
              else
                resolve(@findUntilExhausted(condition))
            else
              reject()
            # return offers to make sure chaining multiple "then"
            # to (cached) loadingPromise from loadMoreOffers won't get messed
            return offers

          @loadMoreOffers().then(loadSuccess, reject)

      findInCache: (condition) ->
        @findInArray(@offers, condition)

      findInArray: (array, condition) ->
        for offer in array
          return offer if condition(offer)

      loadMoreOffers: ->
        @loadingPromise ||= $q (resolve, reject) =>
          @currentPage ||= 0
          @currentPage += 1
          if @totalPage? && (@currentPage > @totalPage)
            return reject()
          options =
            page: @currentPage
            country_code: @countryCode
            offline: true
            tradeable: true
            offer_type: @offerType

          success = (data) =>
            delete @loadingPromise
            @offers = @offers.concat(data.offers)
            PriceReloader.addOffer(offer) for offer in data.offers
            @totalPage = data.meta.total_pages
            resolve(data.offers)

          Offer.query(options).$promise.then(success, reject)
