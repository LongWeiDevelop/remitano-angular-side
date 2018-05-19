'use strict'

angular.module 'remitano'
.controller 'TradeTwoFactorFormController',
($scope, $uibModalInstance) ->
  vm = @
  init = ->
    vm.cancel = cancel
    vm.release = release
    vm.otp = null

  cancel = ->
    $uibModalInstance.dismiss 'Canceled'
    return

  release = ->
    $uibModalInstance.close vm.otp
    return

  init()
