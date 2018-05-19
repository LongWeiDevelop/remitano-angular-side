'use strict'

angular.module 'remitano'
.directive "coinTransactionsList", (CoinTransaction, SocketWrapper, RAILS_ENV) ->
  restrict: "E"
  scope: {}
  templateUrl: "coin_transactions/list/list.tmpl.html"
  controllerAs: "vm"
  controller: ($scope)->
    vm = this
    init = ->
      vm.currentPage = 1
      vm.loadCoinTransactions = loadCoinTransactions
      vm.pageChanged = (page) ->
        loadCoinTransactions(page)
      # loadCoinTransactions()

    loadCoinTransactions = (page) ->
      vm.fetching = true
      vm.errorFetching = false
      loadSuccess = (data) =>
        vm.btcTransactions = data.coin_transactions
        vm.paginationMeta = data.meta
        # subscribeChanges(data.meta.pusher_channel)
        vm.fetching = false        

      loadError = (response) =>
        vm.errorFetching = true
        vm.fetching = false

      params =
        coin_currency: RAILS_ENV.coin_currency
        page: page
      CoinTransaction.get params, loadSuccess, loadError

    subscribeChanges = (channel) ->
      return if vm.subscribed
      SocketWrapper.subscribe($scope, channel, "update_coin_transaction", (event, data) ->
        console.log(data)
        index = vm.btcTransactions.findIndex ((output) -> output.id == data.id)
        oldCoinTransaction = vm.btcTransactions[index]
        if oldCoinTransaction
          angular.extend(oldCoinTransaction, data)
        else
          return if vm.btcTransactions.length > 0 && (data.id < vm.btcTransactions[0].id)
          data.animateClass = "animate-row"
          vm.btcTransactions.unshift data
        console.log(vm.btcTransactions)
      )
      vm.subscribed = true

    init()
    return

