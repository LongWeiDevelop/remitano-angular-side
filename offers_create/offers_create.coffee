'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider
  .state 'root.offerCreate',
    url: '/offers/create?type'
    templateUrl: 'offers_create/offers_create.tmpl.html'
    controller: 'OfferFormController'
    controllerAs: "vm"
    params:
      type: 'sell'
    data:
      title: 'offer_create_new_offer'
    resolve:
      mode: -> 'create'
  .state 'root.offerCreateProceed',
    url: '/offers/create-proceed'
    templateUrl: 'offers_create/offers_create_proceed.tmpl.html'
    controller: 'OffersCreateProceedController'
    controllerAs: "vm"
    params:
      type: 'sell'
    data:
      title: 'offer_create_new_offer'
      access: AccessLevels.user
      noSEO: true
