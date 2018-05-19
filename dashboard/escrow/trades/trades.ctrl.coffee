'use strict'

angular.module 'remitano'
.controller 'DashboardEscrowTradesController', ($state, $stateParams, Trade) ->
  vm = this
  init = ->
    vm.tradeStatus = $stateParams.tradeStatus
    if (vm.tradeStatus != "active") && (vm.tradeStatus != "closed")
      return $state.go("root.home")

  init()
  return
