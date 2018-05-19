'use strict'

angular.module 'remitano'
.controller 'LoginController',
($scope, Auth, $state, $translate, Flash, Translate, $analytics, RAILS_ENV) ->
  Translate($scope)

  vm = @
  init = ->
    if Auth.isLoggedIn()
      return Auth.goToAfterLoginState()
    vm.user = { }
    vm.requestLogin = requestLogin

  requestLogin = (form) ->
    Flash.clear()
    if form.$valid
      form.submitting = true
      Auth.requestLogin
        email: vm.user.email
        ref: RAILS_ENV.ref
        source_url: RAILS_ENV.source_url

      .then (response) ->
        $analytics.eventTrack('userRequestLogin', {  category: 'user', label: 'Successfully' })
        $.jStorage.set('login_email', vm.user.email)
        $state.go("root.login_proceed", email: vm.user.email)

      .catch (err) ->
        Flash.displayError(err.data)

      .finally ->
        form.submitting = false

  init()
  return
