'use strict'

angular.module 'remitano'
.controller 'LoginUsernameController',
(Auth, $state, $window, $translate, Flash, MobileApp, User, $analytics) ->
  vm = @
  init = ->
    vm.user =
      email: $state.params.email,
      login_token: $state.params.login_token

    vm.submitUsername = submitUsername

  relogin = ->
    $state.go("root.login", email: vm.user.email)

  submitUsername = (form) ->
    return if form.submitting
    form.submitting = true

    Flash.clear()

    Auth.login(vm.user).then (response) ->
      if response.status == 'username_required'
        Flash.add('info', $translate.instant("account_username_required"))
      else
        $analytics.eventTrack('userLogin', {  category: 'user', label: 'Successfully' })
        Flash.addCache('info', $translate.instant("account_logged_in"))
        Auth.goToAfterLoginState()
    .catch (err) ->
      if err.status != 422 # username is invalid
        Flash.storeErrorForDisplay(err.data)
        relogin()
      else
        Flash.displayError(err.data)
    .finally ->
      form.submitting = false

  init()
  return

