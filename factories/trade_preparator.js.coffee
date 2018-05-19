'use strict'

angular.module 'remitano'
  .factory 'TradePreparator', (Auth, $state, $stateParams) ->
    prepare: (trade, offer) ->
      $.jStorage.set('pendingTrade', trade)
      $.jStorage.set('pendingTradeOffer', offer)
      $.jStorage.set('leadState', $state.current.name)
      $.jStorage.set('leadStateParams', $stateParams)
      if Auth.isLoggedIn()
        $state.go("root.tradeCreate")
      else
        Auth.setAfterLoginState "root.tradeCreate"
        Auth.promptForLogin()

    getTrade: ->
      $.jStorage.get('pendingTrade')

    getOffer: ->
      $.jStorage.get('pendingTradeOffer')

    cleanUp: ->
      $.jStorage.deleteKey('pendingTrade')
      $.jStorage.deleteKey('pendingTradeOffer')
      $.jStorage.deleteKey('leadState')
      $.jStorage.deleteKey('leadStateParams')

    goBack: ->
      if (leadState = $.jStorage.get('leadState'))
        leadStateParams = $.jStorage.get('leadStateParams')
      else
        leadState = "root.landing"
        leadStateParams = null

      @cleanUp()
      $state.go(leadState, leadStateParams)



