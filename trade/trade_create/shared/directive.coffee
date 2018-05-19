'use strict'

angular.module 'remitano'
.directive "tradeCreateShared", () ->
  restrict: "E"
  templateUrl: "trade/trade_create/shared/tmpl.html"
  scope:
    offer: "<"
    isRemittance: "<"
    onProceedToCreation: "&"
  controllerAs: "vm"
  bindToController: true
  controller: (Trade, Flash, $translate, $state, $analytics, TradePreparator, Auth, RAILS_ENV) ->
    vm = @
    init = ->
      vm.offerType = vm.offer?.offer_type
      vm.onPhoneNumberUpdated = onPhoneNumberUpdated
      vm.onPaymentDetailsSubmitted = onPaymentDetailsSubmitted
      vm.phoneNumberVerified = Auth.currentUser().phone_number_status == 'verified'
      vm.dismissWarnings = dismissWarnings
      vm.handleAccountVerified = handleAccountVerified
      vm.calculateStep = calculateStep
      calculateStep()

    dismissWarnings = ->
      vm.step = "submitting"
      vm.onProceedToCreation?($paymentDetails: vm.paymentDetails)

    handleAccountVerified = ->
      Auth.reloadUser().then (-> calculateStep() )

    tradeNeedVerify = ->
      vm.offerType == "sell" && vm.offer.require_verified_buyer && Auth.currentUser().doc_status != "verified"

    calculateStep = ->
      if needPhoneNumber()
        if vm.step != 'verify_phone'
          Flash.add('warning', $translate.instant('account_phone_is_required'))
        vm.step = "verify_phone"
      else if vm.offerType == "buy" && !vm.paymentDetails?
        vm.step = "input_payment_details"
      else if tradeNeedVerify()
        Flash.add('warning', $translate.instant('account_verification_is_required_to_buy'))
        vm.step = "need_verify"
      else if needFiatWallet()
        Flash.add('warning', $translate.instant('fiat_wallet_is_require_to_buy', currency: RAILS_ENV.current_currency))
        vm.step = "need_fiat_wallet"
      else
        vm.step = "warning"

    needFiatWallet = ->
      return false unless vm.offer.offer_type == 'sell'
      return false unless RAILS_ENV.fiat_wallet
      return false unless vm.offer.payment_method == 'local_bank'
      return false unless RAILS_ENV.centralized
      return false if Auth.hasFiatWallet()
      return true if vm.offer.country_code == 'in'
      vm.offer.bank_name == RAILS_ENV.fiat_payment_method.bank_name

    needPhoneNumber = ->
      return false if vm.phoneNumberVerified
      return false unless Auth.isLoggedIn()
      return true if RAILS_ENV.country_strict[vm.offer?.country_code]
      vm.offerType == 'buy'

    onPhoneNumberUpdated = (status) ->
      if status == "verified"
        vm.phoneNumberVerified = true
      calculateStep()

    onPaymentDetailsSubmitted = (paymentDetails) ->
      vm.paymentDetails = paymentDetails
      calculateStep()

    init()
    return
