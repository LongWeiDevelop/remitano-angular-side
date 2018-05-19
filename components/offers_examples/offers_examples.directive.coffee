'use strict'

angular.module 'remitano'
.directive 'offersExamples', (Offer) ->
  restrict: 'E'
  templateUrl: 'components/offers_examples/offers_examples.tmpl.html'
  scope:
    limit: "="
    offerType: "@"
  controllerAs: 'vm'
  controller: () ->
