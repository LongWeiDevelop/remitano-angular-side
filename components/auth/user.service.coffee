'use strict'

angular.module 'remitano'
.factory 'User', ($resource) ->
  $resource '/api/v1/users/:action',
    action: '@action'
  ,
    requestLogin:
      method: 'POST'
      params:
        action: 'request_login'
    login:
      method: 'POST'
      params:
        action: 'login'
    logout:
      method: 'POST'
      params:
        action: 'logout'

    extendToken:
      method: 'POST'
      params:
        action: 'extend_token'

    get:
      method: 'GET'
      params:
        action: 'me'

    recentUsedBtcAddresses:
      method: 'GET'
      isArray: true
      params:
        action: 'recent_used_coin_addresses'

    recentUsedIps:
      method: 'GET'
      isArray: false
      params:
        action: 'recent_used_ips'

    document:
      method: 'GET'
      params:
        action: 'document'

    update:
      method: 'POST'
      params:
        action: 'update'

    updateNewAccount:
      method: 'POST'
      params:
        action: 'update_new_account'

    generateApi:
      method: 'POST'
      params:
        action: 'generate_api'

    configNotifications:
      method: 'POST'
      params:
        action: 'config_notifications'

    twoFactorRequestRemoval:
      method: 'POST'
      params:
        action: 'two_factor_request_removal'
    twoFactorUndoRemoval:
      method: 'POST'
      params:
        action: 'two_factor_undo_removal'
    markWarningAsSeen:
      method: 'POST'
      params:
        action: 'mark_warning_as_seen'

    pendingDeposit:
      method: 'GET'
      params:
        action: 'pending_deposit'
