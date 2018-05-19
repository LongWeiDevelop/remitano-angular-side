'use strict'

angular.module 'remitano'
.directive "tradeLiveUpdater", ->
  restrict: "E"
  template: ""
  replace: true
  scope:
    tradeWithRole: "<"
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, SocketWrapper, Auth, Trade)->
    vm = this
    init = ->
      $scope.$watch "vm.tradeWithRole.trade.ref", (ref) ->
        return unless ref?
        subscribeTradeChannel(ref)

      $scope.$on "$destroy", ->
        clearTimeout(vm.timeout)

      scheduleLoadTrade() if shouldUpdateTrade()

    shouldUpdateTrade = ->
      if !vm.tradeWithRole?.coin_deposit_address && vm.tradeWithRole?.role == 'seller'
        return true
      else
        return false unless vm.tradeWithRole?.use_fiat_deposit
        return false if vm.tradeWithRole?.payment_details?
        true

    shouldWaitForBtcAddress = ->

    subscribeTradeChannel = (ref) ->
      user_id = Auth.currentUser().id
      SocketWrapper.subscribe $scope, "private-user_#{user_id}@trade_#{ref}", "updated", handleTradeUpdated

    loadTrade = ->
      Trade.get({ref: vm.tradeWithRole.trade.ref}, getTradeSuccess, getTradeError)

    scheduleLoadTrade = ->
      vm.timeout = setTimeout loadTrade, 3000

    getTradeError = ->
      scheduleLoadTrade() if shouldUpdateTrade()

    getTradeSuccess = (data) ->
      handleTradeUpdated({}, {trade_with_role: data})
      scheduleLoadTrade() if shouldUpdateTrade()

    handleTradeUpdated = (event, data) ->
      angular.extend(vm.tradeWithRole, data.trade_with_role)
      clearTimeout(vm.timeout) unless shouldUpdateTrade()

    init()
    return
