'use strict'

angular.module 'remitano'
.controller 'OffersCreateProceedController',
($scope, Offer, Flash, $state, $translate, $analytics, OfferPreparator, Auth, RAILS_ENV) ->
  vm = @

  init = ->
    vm.pendingOffer = OfferPreparator.getOffer()
    vm.onPhoneNumberUpdated = onPhoneNumberUpdated
    vm.phoneNumberVerified = Auth.currentUser().phone_number_status == 'verified'
    vm.onFiatWalletReady = onFiatWalletReady
    calculateStep()

  calculateStep = ->
    if needPhoneNumber()
      if vm.step != 'verify_phone'
        Flash.add('warning', $translate.instant('account_phone_is_required'))
      vm.step = "verify_phone"
    else if needFiatWallet()
      if vm.step != 'create_fiat_wallet'
        Flash.add('warning', $translate.instant('fiat_wallet_is_require_to_create_offer', currency: vm.pendingOffer.currency))
      vm.step = "create_fiat_wallet"
    else
      vm.step = "submitting"
      createOffer()

  needFiatWallet = ->
    return false unless vm.pendingOffer.offer_type == 'buy'
    return false unless RAILS_ENV.fiat_wallet
    return false unless !Auth.hasFiatWallet()
    return false unless vm.pendingOffer.payment_method == 'local_bank'
    return true if vm.pendingOffer.country_code == 'in'
    vm.pendingOffer.payment_details.bank_name == RAILS_ENV.fiat_payment_method.bank_name

  onFiatWalletReady = ->
    calculateStep()

  needPhoneNumber = ->
    return false if vm.phoneNumberVerified
    true

  onPhoneNumberUpdated = (status) ->
    if status == "verified"
      vm.phoneNumberVerified = true
    calculateStep()

  createOffer = ->
    return $state.go("root.offerCreate") unless vm.pendingOffer?
    vm.creating = true
    Offer.save vm.pendingOffer, (data) ->
      vm.creating = false
      OfferPreparator.cleanUp()
      if data.is_action_confirmation
        $state.go("root.actionConfirmationConfirm", id: data.id)
      else
        Flash.addCache('success', $translate.instant("offer_offer_created_successfully"), true)
        $analytics.eventTrack('createOffer', {  category: 'offer' })
        $state.go("root.offerDetails", id: data.id, canonical: data.canonical_name)
    , (err) ->
      vm.creating = false
      Flash.addCache('danger', err.data?.error || $translate.instant("other_something_went_wrong"))
      OfferPreparator.goBack()

  init()
  return
