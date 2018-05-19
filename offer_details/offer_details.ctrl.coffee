'use strict'

angular.module 'remitano'
.controller 'OfferDetailsController', ($scope, $translate, $state, $stateParams,
Offer, Flash, DynamicTitle, SeoBridge, $analytics, Auth, RAILS_ENV) ->
  vm = @
  init = ->
    vm.id = $stateParams.id
    vm.getOffer = getOffer
    vm.isItSafeOpen = false
    vm.whenReceiveOpen = false
    # getOffer()

  onGetOfferError = ->
    vm.errorGettingOffer = true
    vm.gettingOffer = false

  onGetOfferSuccess = (offer) ->
    vm.offer = offer
    vm.gettingOffer = false
    vm.errorGettingOffer = false

    if vm.offer.canonical_name != $stateParams.canonical
      $state.go("root.offerDetails", { id: vm.offer.id, canonical: vm.offer.canonical_name }, notify: false)
    else
      data =
        offer_id: vm.offer.id
        category: 'offer'
        label: 'viewed'
      $analytics.eventTrack('viewSingleOffer', data)

    # title = seoTitle()
    # DynamicTitle.setTranslated(title)
    # SeoBridge.publish(title: title)

  seoTitle = ->
    params =
      currency: vm.offer.currency
      country: RAILS_ENV.country_names[vm.offer.country_code]
      method: vm.offer.payment_descriptions
      username: vm.offer.username

    $translate.instant("seo_#{vm.offer.offer_type}_offer_title", params, null, null, "sce")

  getOffer = ->
    vm.gettingOffer = true
    vm.errorGettingOffer = false
    Offer.get(id: vm.id, onGetOfferSuccess, onGetOfferError)

  # init()
  return
