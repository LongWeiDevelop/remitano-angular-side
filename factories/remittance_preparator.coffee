'use strict'

angular.module 'remitano'
  .factory 'RemittancePreparator', (Auth, $state, $stateParams) ->
    prepare: (offer) ->
      $.jStorage.set('pendingRemittance', offer)
      if Auth.isLoggedIn()
        $state.go("root.remittanceCreateProceed")
      else
        Auth.setAfterLoginState "root.remittanceCreateProceed"
        Auth.promptForLogin()

    getRemittance: ->
      $.jStorage.get('pendingRemittance')

    cleanUp: ->
      $.jStorage.deleteKey('pendingRemittance')

    goBack: ->
      $state.go("root.remittance.new")
