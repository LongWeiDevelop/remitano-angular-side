'use strict'

angular.module 'remitano'
.directive "localBankPaymentDetails", ->
  restrict: "E"
  scope:
    paymentDetails: "<"
    fixedBankName: "<"
    buying: "<"
    countryCode: "="
  templateUrl: "offers_create/local_bank_payment_details/local_bank_payment_details.tmpl.html"
  controllerAs: 'vm'
  bindToController: true
  controller: ($scope, $stateParams, CountryBank, RAILS_ENV) ->
    vm = @
    vm.availableBanks = []
    $scope.$watch "vm.countryCode", (countryCode) ->
      return unless countryCode?
      CountryBank.byCountryCode(countryCode).then (bankNames) ->
        vm.availableBanks = bankNames
      vm.additional_bank_fields = RAILS_ENV.additional_bank_fields[countryCode]

    $scope.$watch "vm.paymentDetails.bank_name", (bankName) ->
      vm.autoBankAccountNumberInput = if bankName?
        bankName == RAILS_ENV.fiat_payment_method.bank_name &&
          RAILS_ENV.fiat_payment_method.auto_populate_bank_account_name
      else
        false

    return
