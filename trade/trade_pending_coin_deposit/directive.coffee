'use strict'

angular.module 'remitano'
.directive 'tradePendingCoinDeposit', ->
  restrict: "E"
  templateUrl: "trade/trade_pending_coin_deposit/tmpl.html"
  scope:
    coinDepositAddress: "="
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, RAILS_ENV, CoinAccount, Auth, SocketWrapper, MobileApp) ->
    vm = this
    init = ->
      vm.MobileApp = MobileApp
      loadPendingCoinDeposit()


    loadPendingCoinDeposit = () ->
      loadSuccess = (data) =>
        vm.pendingDeposit = data.pending_tx
        subscribeChanges(data.meta.pusher_channel)

      params =
        id: vm.coinDepositAddress
        coin_currency: RAILS_ENV.coin_currency
      CoinAccount.pendingDeposit(params, loadSuccess)

    subscribeChanges = (channel) ->
      return if vm.subscribed
      user_id = Auth.currentUser().id
      SocketWrapper.subscribe($scope, channel, "updated", (event, data) ->
        vm.pendingDeposit = data.pending_tx
      )
      vm.subscribed = true

    init()
    return
