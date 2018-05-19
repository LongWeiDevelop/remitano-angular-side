'use strict'

angular.module 'remitano'
.directive 'tradeReminding', ->
  restrict: "E"
  templateUrl: "trade/trade_reminding/tmpl.html"
  scope:
    tradeWithRole: "="
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, Flash, $translate, dialogs, $uibModal, Trade) ->
    vm = this
    init = ->
      vm.remindTrader = remindTrader
      vm.trade = vm.tradeWithRole?.trade
      vm.role = vm.tradeWithRole?.role
      vm.remindee = (
        if vm.role == 'buyer'
          vm.trade.seller_username
        else
          vm.trade.buyer_username
      )

    $scope.$watch "vm.tradeWithRole.trade", (trade) ->
      vm.trade = trade

    _remindTraderSuccess = (res) ->
      Flash.add("success", $translate.instant("trade_remind_trader_success", {username: vm.remindee}), true)
      vm.reminding = false
      vm.tradeWithRole.trade = res.trade

    _remindTraderError = (res) ->
      vm.reminding = false
      dialogs.error($translate.instant("DIALOGS_ERROR"), res.data?.error || $translate.instant("other_internal_server_error"))

    remindTrader = ->
      uibModalInstance = $uibModal.open(
        templateUrl: 'trade/remind_choices/tmpl.html'
        controller: 'RemindChoicesController as vm'
        size: 'md'
        resolve:
          trade: -> vm.trade
      )

      uibModalInstance.result.then((type) -> reallyRemindTrader(type))

    reallyRemindTrader = (via) ->
      return if vm.reminding
      vm.reminding = true
      Trade.remindTrader({ ref: vm.trade.ref, via: via, role: vm.role }, _remindTraderSuccess, _remindTraderError)

    init()
    return
