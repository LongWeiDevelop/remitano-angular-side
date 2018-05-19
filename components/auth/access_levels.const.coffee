'use strict'

angular.module 'remitano'
.constant 'AccessLevels',
  anonymous: 1,
  user: 2

angular.module 'remitano'
.run ($rootScope, Flash, Auth, AccessLevels, $state, $translate, MobileApp) ->

  # authenticate each route state
  $rootScope.$on '$stateChangeStart',
  (event, toState, toParams, fromState, fromParams) ->
    accessLevel = toState.data?.access
    if toState.data?.title
      MobileApp.setTitle($translate.instant(toState.data?.title))
    if toState.name == 'root.landing'
      MobileApp.setTitle('Remitano')

    unless Auth.authorize(accessLevel)
      event.preventDefault()
      if Auth.isTemporary()
        Auth.setAfterLoginState(toState.name, toParams)
        if $state.$current.name == 'root.updateAccount' && toState.name != 'root.updateAccount'
          Flash.add('info', $translate.instant("other_update_account_first"), true, true)
        else
          Flash.addCache('info', $translate.instant("other_update_account_first"), true, true)
        $state.go('root.updateAccount')
      else if Auth.isLoggedIn()
        Auth.goToAfterLoginState()
      else
        Auth.setAfterLoginState(toState.name, toParams)
        if $state.$current.name == 'root.login' && toState.name != 'root.login'
          Flash.add('info', $translate.instant("other_login_first"), true, true)
        else
          Flash.addCache('info', $translate.instant("other_login_first"))

        $state.go('root.login', country: toParams.country, locale: toParams.locale, coin_currency: toParams.coin_currency)
