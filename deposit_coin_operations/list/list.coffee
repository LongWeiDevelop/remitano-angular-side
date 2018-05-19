'use strict'

angular.module 'remitano'
.directive "depositCoinOperationsList", (CoinDepositOperation, SocketWrapper, Auth) ->
  restrict: "E"
  scope: {}
  templateUrl: "deposit_coin_operations/list/list.tmpl.html"
  controllerAs: "vm"
  controller: ($scope) ->
    vm = this

    init = ->
      vm.currentPage = 1
      vm.pageChanged = (page) ->
        loadCoinDepositOperations(page)
      loadCoinDepositOperations()


    loadCoinDepositOperations = (page) ->
      vm.fetching = true
      vm.errorFetching = false
      loadSuccess = (data) =>
        vm.coinTransactions = data.coin_deposit_operations
        vm.paginationMeta = data.meta
        subscribeChanges(data.meta.pusher_channel)
        vm.fetching = false

      loadError = (response) =>
        vm.errorFetching = true
        vm.fetching = false
      CoinDepositOperation.get {page: page}, loadSuccess, loadError

    subscribeChanges = (channel) ->
      return if vm.subscribed
      user_id = Auth.currentUser().id
      SocketWrapper.subscribe($scope, channel, "private-user_#{user_id}@update_coin_transaction", (event, data) ->
        oldCoinDepositOperation = vm.coinTransactions.find((output) ->
          output.id == data.id
        )
        if oldCoinDepositOperation
          angular.extend(oldCoinDepositOperation, data)
        else
          return if vm.coinTransactions.length > 0 && (data.id < vm.coinTransactions[0].id)
          data.animateClass = "animate-row"
          vm.coinTransactions.unshift data
      )
      vm.subscribed = true

    init()
    return
