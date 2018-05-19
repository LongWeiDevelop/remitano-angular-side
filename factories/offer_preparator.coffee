'use strict'

angular.module 'remitano'
  .factory 'OfferPreparator', (Auth, $state, $stateParams) ->
    prepare: (offer) ->
      $.jStorage.set('pendingOffer', offer)
      if Auth.isLoggedIn()
        $state.go("root.offerCreateProceed")
      else
        Auth.setAfterLoginState "root.offerCreateProceed"
        Auth.promptForLogin()

    getOffer: ->
      $.jStorage.get('pendingOffer')

    cleanUp: ->
      $.jStorage.deleteKey('pendingOffer')

    goBack: ->
      $state.go("root.offerCreate")
