'use strict'

angular.module 'remitano'
.factory 'Auth', ($rootScope, $http, User, $q, AccessLevels, $state, $injector, Intercom,
MobileApp, $translate, Flash, $window, $stateParams, RAILS_ENV, $ngRedux,
$httpParamSerializerJQLike) ->
  _currentUser: null
  _oldUser: null

  oldUser: ->
    @_oldUser

  fetchSsoToken: ->
    fetchSuccess = (req) =>
      token = req.data
      if token?.length > 0
        @_ssoToken = token
        $ngRedux.dispatch
          type: 'remitano/Shared/CurrentUser/SET_SSO_TOKEN'
          payload: token
        unless @currentUser()?
          @reloadUser(true).then (user) =>
            @signUserIn(token, user)

    fetchError = (data, status, headers, config) =>
      console.warn "fetchSsoToken error", arguments

    options =
      method: 'GET'
      withCredentials: true
      url: RAILS_ENV.sso_server_url + '/fetch'
      transformResponse: (text) -> text

    $http(options).then(fetchSuccess, fetchError)

  shareTokenToSso: (token) ->
    options =
      method: "POST"
      url: RAILS_ENV.sso_server_url + '/store'
      withCredentials: true
      headers:
        'Content-Type': 'application/x-www-form-urlencoded'
      data: $httpParamSerializerJQLike(token: token)
      transformResponse: undefined

    shareSuccess = (data) ->
      # console.warn "shareTokenToSso", "success", data

    shareError = (data) ->
      # console.warn "shareTokenToSso", "error", data

    $http(options).then(shareSuccess, shareError)

  currentUser: ->
    @_currentUser ||= if $.jStorage.get('user')
      new User($.jStorage.get('user'))

  hasFiatWallet: ->
    _.includes(@currentUser()?.available_fiat_wallet_countries, RAILS_ENV.current_country)

  promptForLogin: ->
    Flash.addCache('warning', $translate.instant("register_or_login_to_continue"))
    $state.go("root.login")

  requestLogin: (user) ->
    params = angular.extend user,
      device_identifier: $window.DEVICE_IDENTIFIER
    User.requestLogin(params, ((data) =>
    ), (err) =>
    ).$promise

  login: (user) ->
    params = angular.extend user,
      device_identifier: $window.DEVICE_IDENTIFIER
    User.login(params, ((data) =>
      if data.status != 'username_required'
        @signUserIn(data.token, data.user)
        $injector.get('SocketWrapper').reconnect()
    ), (err, data) =>
      @logout("login failed")
    ).$promise

  signUserIn: (token, user) ->
    #Hack to inject token to react redux store
    $ngRedux.dispatch
      type: 'remitano/Shared/CurrentUser/SET_TOKEN'
      payload: token
    $.jStorage.set 'token', token
    @assignNewUser(user)
    $rootScope.$broadcast("userLoggedIn", {})

  logout: (cause) ->
    @_oldUser = @currentUser()
    #Hack to clear user data from redux store
    $ngRedux.dispatch
      type: 'remitano/Shared/CurrentUser/LOG_USER_OUT'
    $.jStorage.deleteKey 'token'
    $.jStorage.deleteKey 'ssoToken'
    $.jStorage.deleteKey 'user'
    $.jStorage.deleteKey 'coinAccount'
    $.jStorage.deleteKey 'pendingNotificationCount'
    @_currentUser = null
    MobileApp.sendJstorage()
    Intercom.shutdown() unless MobileApp.exists()
    $rootScope.$broadcast("userLoggedOut", {})
    $injector.get('SocketWrapper').reconnect()
    @_ssoToken = null
    @shareTokenToSso(null)

  reloadUser: (sso = false) ->
    User.get {}
    , (data) =>
      @assignNewUser(data)
    , (response) =>
      return if sso
      @logout() if response?.status == 401
    .$promise

  createUser: (user) ->
    User.save user,
      (data) =>
        $.jStorage.set 'token', data.token
        $.jStorage.set 'user', data.user
        @signUserIn(data.token, data.user)
        $injector.get('SocketWrapper').reconnect()
      , (err) =>
        @logout("createUser failed")
    .$promise

  assignNewUser: (user) ->
    if $.jStorage.get('token')
      $ngRedux.dispatch
        type: 'remitano/Shared/CurrentUser/SET_CURRENT_USER'
        payload: if user.toJSON then user.toJSON() else user
      $.jStorage.set 'user', user
      @_currentUser = null
      @_oldUser = null
      MobileApp.sendJstorage()
      $rootScope.$broadcast("userReloaded", {})
      @initializeSettings()
      unless @extendTokenTimer
        @extendTokenTimer = setInterval((=> @extendToken()), 5*60*1000)
        @extendToken()

  extendToken: ->
    User.extendToken {}, (data) =>
      #Hack to inject token to react redux store
      $ngRedux.dispatch
        type: 'remitano/Shared/CurrentUser/SET_TOKEN'
        payload: data.token
      $.jStorage.set('token', data.token)
      @shareTokenToSso(data.token)

  initializeSettings: ->
    if (user = @currentUser())
      country = user.country_code

  updateNewAccount: (user) ->
    self = @
    User.updateNewAccount user,
      (data) ->
        self.assignNewUser(data)
      , (err) =>
        console.log(err)
    .$promise

  updateProfile: (user) ->
    self = @
    User.update user,
      (data) ->
        self.assignNewUser(data)
      , (err) =>
        console.log(err)
    .$promise

  generateApi: ->
    self = @
    User.generateApi {},
      (data) ->
        self.reloadUser()
      , (err) =>
        console.log(err)
    .$promise

  changePassword: (currentPassword, newPassword) ->
    User.changePassword
      current_password: currentPassword
      new_password: newPassword
    .$promise

  enableTwoFactor: (oneTimeCode) ->
    success = (data) =>
      @assignNewUser(data)

    $http.post('/api/v1/two_factor_auth/enable', {one_time_code: oneTimeCode})
      .success(success)

  disableTwoFactor: (oneTimeCode) ->
    success = (data) =>
      @assignNewUser(data)

    $http.post('/api/v1/two_factor_auth/disable', {one_time_code: oneTimeCode})
      .success(success)

  enableTouchId: (oneTimeCode) ->
    success = (data) =>
      @assignNewUser(data.user)
      MobileApp.enableTouchId(data.two_factor_sub_key)
      # alert(data.two_factor_sub_key)

    $http.post('/api/v1/two_factor_auth/enable_touch_id', {one_time_code: oneTimeCode})
      .success(success)

  disableTouchId: () ->
    success = (data) =>
      @assignNewUser(data)

    $http.post('/api/v1/two_factor_auth/disable_touch_id')
      .success(success)

  isLoggedIn: ->
    !!@currentUser()

  domain: ->
    @domainFor($rootScope.coin_currency)

  domainFor: (currency) ->
    domain = "remitano.com"
    domain = "#{currency}.remitano.com" if currency != "btc"
    domain

  getToken: -> $.jStorage.get 'token'

  getSsoToken: -> @_ssoToken

  displayName: ->
    return null unless @isLoggedIn()
    @currentUser().username || @currentUser().email

  confirmMail: (mailConfirmationToken, callback) ->
    self = @
    cb = callback || angular.noop
    deferred = $q.defer()

    User.confirmMail
      confirmation_token: mailConfirmationToken
    , (data) ->
      $.jStorage.set 'token', data.token
      $.jStorage.set 'user', data.user
      self.reloadUser()
      deferred.resolve(data)
      cb()
    , (err) ->
      deferred.reject(err)
      cb(err)
    .$promise

  sendConfirmationMail: (params, callback) ->
    cb = callback || angular.noop
    User.sendConfirmationMail(params ,(user) ->
      cb(user)
    , (err) ->
      cb(err)
    ).$promise

  sendResetPasswordMail: (params) ->
    User.sendResetPasswordMail(params).$promise

  resetPassword: (resetPasswordToken, newPassword, newPasswordConfirmation) ->
    User.resetPassword({
      reset_password_token: resetPasswordToken,
      password: newPassword
      password_confirmation: newPasswordConfirmation
    }).$promise

  authorize: (accessLevel) ->
    if accessLevel is AccessLevels.user
      @isLoggedIn() && !@isTemporary()
    else if accessLevel is AccessLevels.anonymous
      !@isLoggedIn()
    else
      true

  isTemporary: ->
    return false unless @currentUser()
    @currentUser()["temporary"]

  afterLoginState: ->
    $.jStorage.get('afterLoginState')

  afterLoginParams: ->
    $.jStorage.get('afterLoginParams') || {}

  setAfterLoginState: (name, params) ->
    return if name == "root.logout"
    $.jStorage.set('afterLoginState', name)
    $.jStorage.set('afterLoginParams', params)

  goToAfterLoginState: ->
    if @afterLoginState()
      $state.go(@afterLoginState(), @afterLoginParams())
      $.jStorage.deleteKey('afterLoginState')
      $.jStorage.deleteKey('afterLoginParams')
    else
      $state.go('root.landing')

  pusherSubscribable: (channel)->
    return true unless /^private-user_/.test(channel)
    @isLoggedIn() && pusher_client.config.authEndpoint == '/api/v1/pusher_auth/auth'
