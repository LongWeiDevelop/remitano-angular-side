'use strict'

angular.module 'remitano'
.controller 'RemindChoicesController', ($uibModalInstance, trade) ->
  vm = this
  vm.trade = trade
  vm.optionSelected = (option) ->
    $uibModalInstance.close(option)

  vm.close = ->
    $uibModalInstance.dismiss('close')

  vm.classFor = (option) ->
    "btn-#{option.clazz} btn-#{option.name}-remind"

  vm.options = [
    {
      name: 'app'
      clazz: 'primary'
    }
    {
      name: 'phone'
      clazz: 'success'
    }
  ]

  return

