'use strict'

angular.module 'remitano'
.directive "otherPaymentDetails", ->
  restrict: "E"
  scope:
    paymentDetails: "<"
    paymentMethod: "<"
  templateUrl: "offers_create/other_payment_details/other_payment_details.tmpl.html"
  controllerAs: 'vm'
  bindToController: true
  controller: (RAILS_ENV) ->
    vm = this
    vm.additionalFields = RAILS_ENV.payment_method_additional_fields[vm.paymentMethod]
    return
