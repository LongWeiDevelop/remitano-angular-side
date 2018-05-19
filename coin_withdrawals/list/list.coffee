'use strict'

angular.module 'remitano'
.directive "coinWithdrawalsList", ($rootScope, $timeout, RAILS_ENV, CoinWithdrawal, Auth, SocketWrapper) ->
  restrict: "E"
  scope: {}
  templateUrl: "coin_withdrawals/list/list.tmpl.html"
  controllerAs: "vm"
  controller: ($scope) ->
    vm = this
    init = ->
      vm.pageChanged = loadCoinWithdrawals
      # loadCoinWithdrawals()
      # subscribeChanges()

    loadCoinWithdrawals = (page) ->
      vm.fetching = true
      vm.errorFetching = false
      loadSuccess = (data) =>
        vm.coinWithdrawals = data.coin_withdrawals
        vm.paginationMeta = data.meta
        vm.fetching = false

      loadError = ->
        vm.errorFetching = true
        vm.fetching = false
      params =
        coin_currency: RAILS_ENV.coin_currency
        page: page
      CoinWithdrawal.get params, loadSuccess, loadError

    subscribeChanges = ->
      if Auth.currentUser()
        user_id = Auth.currentUser().id
        SocketWrapper.subscribe($scope, "private-user_#{user_id}@user_coin_withdrawal_channel_#{user_id}", "update", (event, newCoinWithdrawal) ->
          oldCoinWithdrawal = vm.coinWithdrawals.find((order) -> order.id == newCoinWithdrawal.id)
          return unless oldCoinWithdrawal?
          angular.extend(oldCoinWithdrawal, newCoinWithdrawal)
        )

    init()
    return
