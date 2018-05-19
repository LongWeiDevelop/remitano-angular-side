'use strict'

angular.module 'remitano'
.controller 'LoginProceedController',
($state) ->
  vm = this
  init = ->
    vm.email = $.jStorage.get('login_email')
    unless vm.email?
      $state.go("root.login")

  init()
  return
