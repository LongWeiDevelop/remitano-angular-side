'use strict'

angular.module 'remitano'
.directive "poliPaymentDetails", ->
  restrict: "E"
  scope:
    paymentDetails: "<"
  templateUrl: "offers_create/poli_payment_details/poli_payment_details.tmpl.html"
  controllerAs: 'vm'
  bindToController: true
  controller: ->
    return
