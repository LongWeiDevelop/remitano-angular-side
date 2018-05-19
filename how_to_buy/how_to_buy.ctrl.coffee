'use strict'

angular.module 'remitano'
.controller 'HowToBuyController',
() ->
  vm = @
  init = ->
    vm.openStep1 = true
    vm.openStep2 = true
    vm.openStep3 = true
    vm.openStep4 = true

  init()
  return
