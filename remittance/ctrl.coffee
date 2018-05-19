'use strict'

angular.module 'remitano'
.controller 'RemittanceController', (Auth, $state, $stateParams, $scope) ->
  vm = @
  vm.authenticated = Auth.currentUser()?
  return
