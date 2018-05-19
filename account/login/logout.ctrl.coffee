'use strict'

angular.module 'remitano'
.controller 'LogoutController', (Auth, User, $state) ->
  User.logout().$promise.finally ->
    Auth.logout("LogoutController")
    $state.go("root.landing")

  return true
