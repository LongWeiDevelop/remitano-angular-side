'use strict'

angular.module 'remitano'
.controller 'PartnersPopupController', ($uibModalInstance) ->
  vm = this

  vm.close = ->
    $uibModalInstance.close()

  return

