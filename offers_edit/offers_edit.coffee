'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider
  .state 'root.offerEdit',
    url: '/offers/{id:int}/edit'
    templateUrl: 'offers_edit/offers_edit.tmpl.html'
    controller: 'OfferFormController'
    controllerAs: "vm"
    data:
      title: 'offer_edit_offer'
      access: AccessLevels.user
    resolve:
      mode: -> 'edit'
