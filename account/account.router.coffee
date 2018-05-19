'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider
  .state 'root.login',
    url: '/login'
    templateUrl: 'account/login/login.tmpl.html'
    controller: 'LoginController as vm'
    data:
      title: 'login_or_register'

  .state 'root.login_proceed',
    url: '/login/proceed'
    templateUrl: 'account/login/login_proceed.tmpl.html'
    controller: 'LoginProceedController as vm'
    data:
      title: 'login_or_register'
      noSEO: true

  .state 'root.login_token',
    url: '/login/{email:email}/{login_token:[a-zA-Z0-9]+}?noapp'
    template: "<div/>"
    controller: 'LoginTokenController'
    data:
      noSEO: true

  .state 'root.login_username',
    url: '/login/{email:email}/{login_token:[a-zA-Z0-9]+}/username'
    templateUrl: 'account/login/login_username.tmpl.html'
    controller: 'LoginUsernameController as vm'
    data:
      noSEO: true

  .state 'root.logout',
    url: '/logout'
    controller: 'LogoutController as vm'
    data:
      access: AccessLevels.user
      noSEO: true

  .state 'root.settings',
    url: '/settings?unsubscribe'
    templateUrl: 'account/settings/settings.tmpl.html'
    controller: 'SettingsController as vm'
    data:
      access: AccessLevels.user
      title: 'settings_title'

  .state 'root.settings2',
    url: '/settings/{section:(?:two_factor|touch_id|profile|notification|trusted_devices|blacklist|recent_used_ips)}'
    templateUrl: 'account/settings/settings.tmpl.html'
    controller: 'SettingsController as vm'
    data:
      access: AccessLevels.user
      title: 'settings_title'

  .state 'root.verify',
    url: '/verify'
    templateUrl: 'account/verify/verify.tmpl.html'
    controller: 'VerifyController as vm'
    data:
      access: AccessLevels.user
      title: 'verify_title'

  .state 'root.updateAccount',
    url: '/update-account'
    templateUrl: 'account/update_account/update_account.tmpl.html'
    controller: 'UpdateAccountController as vm'
    data:
      title: 'account_update_account_title'
