'use strict'

angular.module 'remitano'
.controller 'LoginTokenController',
(Auth, $state, $window, $translate, Flash, MobileApp, User, $analytics) ->
  vm = @
  init = ->
    vm.user =
      email: $state.params.email,
      login_token: $state.params.login_token

    if vm.user.login_token
      path = $window.location.pathname
      href = $window.location.href
      host = $window.location.host
      if !MobileApp.exists() && Util.anyIOS() && !$state.params.noapp
        $window.location = "remitano://#{host}#{path}"
        setTimeout ->
          $window.location = href + "?noapp=1"
        , 3000
      else
        login()
    else
      if Auth.isLoggedIn()
        Auth.goToAfterLoginState()
      else
        relogin()

  relogin = ->
    $state.go("root.login", email: vm.user.email)

  requestUsername = ->
    $state.go("root.login_username", vm.user)

  login = ->
    Flash.clear()

    Auth.login
      email: vm.user.email,
      login_token: vm.user.login_token

    .then (response) ->
      if response.status == 'username_required'
        Flash.addCache('info', $translate.instant("account_username_required"))
        $analytics.eventTrack('registerComplete', {  category: 'account', label: 'Successfully' })
        try
          __adroll.record_user 'adroll_segments': '419wbkty'
        catch err
        requestUsername()
      else
        $analytics.eventTrack('userLogin', {  category: 'user', label: 'Successfully' })
        Flash.addCache('info', $translate.instant("account_logged_in"))
        Auth.goToAfterLoginState()

    .catch (err, data) ->
      Flash.addCache('danger', err.data?.error || $translate.instant("other_internal_server_error"))
      relogin()

  init()
  return
