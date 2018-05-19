'use strict'

angular.module 'remitano'
.directive "pendingCoinDepositList", (SocketWrapper, Auth, RAILS_ENV) ->
  restrict: "E"
  scope: {}
  templateUrl: "pending_coin_deposit_list/list/list.tmpl.html"
  controllerAs: "vm"
  controller: ($scope, User) ->
    vm = this

    init = ->
      loadPendingCoinDeposit()

    loadPendingCoinDeposit = () ->
      vm.fetching = true
      vm.errorFetching = false
      loadSuccess = (data) =>
        vm.pendingDeposit = data.pending_tx
        subscribeChanges(data.meta.pusher_channel)
        vm.fetching = false

      loadError = (response) =>
        vm.errorFetching = true
        vm.fetching = false

      User.pendingDeposit({ coin_currency: RAILS_ENV.coin_currency }, loadSuccess, loadError)

    subscribeChanges = (channel) ->
      return if vm.subscribed
      user_id = Auth.currentUser().id
      SocketWrapper.subscribe($scope, channel, "updated", (event, data) ->
        vm.pendingDeposit = data.pending_tx
      )
      vm.subscribed = true

    init()
    return
