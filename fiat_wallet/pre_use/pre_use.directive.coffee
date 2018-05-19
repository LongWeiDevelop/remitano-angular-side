'use strict'

angular.module('remitano')
.directive "fiatWalletPreUse", ->
  restrict: "E"
  scope:
    onFiatWalletReady: "&"
  replace: true
  templateUrl: "fiat_wallet/pre_use/pre_use.tmpl.html"
  controllerAs: "prevm"
  bindToController: true
  controller: (Auth, RAILS_ENV, AccountManager, Flash) ->
    prevm = @
    init = ->
      prevm.country = RAILS_ENV.current_country
      prevm.currency = RAILS_ENV.current_currency
      prevm.countryName = RAILS_ENV.country_names[prevm.country]
      prevm.requestFiatAccount = requestFiatAccount
      prevm.recalculateMode = recalculateMode
      recalculateMode()

    recalculateMode = ->
      prevm.mode = calculateMode()

    calculateMode = ->
      if Auth.hasFiatWallet()
        prevm.onFiatWalletReady()
        return "ready"

      if !RAILS_ENV.country_fiat_deposits[prevm.country]
        return "unsupported"

      if RAILS_ENV.accept_unverified_fiat_deposit
        requestFiatAccount()
        return "requesting"

      if Auth.currentUser().doc_country != prevm.country
        return "cant_use"

      unless isUserVerified()
        return "verify_to_use"

      requestFiatAccount()
      "requesting"

    isUserVerified = ->
      Auth.currentUser().doc_status == "verified"

    requestFiatAccount = ->
      return if prevm.requesting
      Flash.clear()
      prevm.requesting = true
      AccountManager.requestFiatAccount().
        then(onRequestSuccess, onRequestFailure).
        finally(-> prevm.requesting = false)

    onRequestSuccess = ->
      Auth.reloadUser().then ->
        prevm.onFiatWalletReady()

    onRequestFailure = (res) ->
      Flash.displayError(res.data)

    init()
    return
