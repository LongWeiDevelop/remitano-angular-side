'use strict'

angular.module 'remitano'
.directive "tradePaymentDetailsForm", ->
  restrict: "E"
  templateUrl: "trade/trade_payment_details_form/tmpl.html"
  replace: true
  scope:
    paymentMethod: "="
    onSubmitted: "&"
    offerCountry: "="
    offerType: "="
    paymentBank: "="
  controllerAs: "vm"
  bindToController: true
  controller: ($timeout, Auth, $stateParams, CountryBank, RAILS_ENV)->
    vm = @
    init = ->
      vm.submitPaymentDetails = submitPaymentDetails
      paymentMethodKey = _.compact([vm.paymentMethod, vm.paymentBank]).join("-")
      vm.paymentDetails = (Auth.currentUser().recent_payment_details || {})[paymentMethodKey] || {}
      vm.validateInput = validateInput
      if _.includes(["local_bank", "cash_deposit"], vm.paymentMethod)
        if vm.paymentDetails.bank_name != vm.paymentBank
          vm.paymentDetails = {bank_name: vm.paymentBank}
      vm.crossBankSelling = RAILS_ENV.country_cross_bank_selling[vm.offerCountry]

    validateInput = (form, inputName, error = null) ->
      return unless form
      input = form[inputName]
      return false unless form.$submitted
      if error == null
        return input.$invalid
      else
        return input.$error[error]

    submitPaymentDetails = (event, form) ->
      event.preventDefault?()
      $timeout ->
        return unless form.$valid
        vm.onSubmitted?($paymentDetails: vm.paymentDetails)

    init()
    return
