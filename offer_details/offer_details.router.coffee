'use strict'

angular.module 'remitano'
.config ($stateProvider) ->
  $stateProvider
  .state 'root.offerDetails',
    url: '/offers/{id:int}-:canonical'
    templateUrl: 'offer_details/offer_details.tmpl.html'
    controller: 'OfferDetailsController'
    controllerAs: "vm"
    data:
      title: 'main_title_offerdetails'
      head:
        canonicalExtend: (cano, toParams) ->
          "/offers/" + encodeURIComponent("#{toParams.id}-#{toParams.canonical}")
