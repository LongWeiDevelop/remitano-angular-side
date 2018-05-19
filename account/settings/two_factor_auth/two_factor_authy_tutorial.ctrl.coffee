'use strict'

angular.module 'remitano'
.controller 'TwoFactorAuthyTutorialController', ($uibModalInstance) ->
  vm = this

  vm.close = ->
    $uibModalInstance.dismiss('close')

  return

