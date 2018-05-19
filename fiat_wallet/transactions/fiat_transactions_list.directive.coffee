'use strict'

angular.module 'remitano'
.directive "fiatTransactionsList", (FiatTransaction, SocketWrapper, RAILS_ENV) ->
  restrict: "E"
  scope: {}
  templateUrl: "fiat_wallet/transactions/fiat_transactions_list.tmpl.html"
  controllerAs: "vm"
  controller: ($scope)->
    vm = this
    init = ->
      vm.currentPage = 1
      vm.country_code = RAILS_ENV.current_country
      vm.pageChanged = loadFiatTransactions
      loadFiatTransactions()

    loadFiatTransactions = (page) ->
      vm.fetching = true
      vm.errorFetching = false
      loadSuccess = (data) =>
        vm.fiatTransactions = data.fiat_transactions
        vm.paginationMeta = data.meta
        subscribeChanges(data.meta.pusher_channel)
        vm.fetching = false

      loadError = (response) =>
        vm.errorFetching = true
        vm.fetching = false
      FiatTransaction.get {country_code: vm.country_code, page: page}, loadSuccess, loadError

    subscribeChanges = (channel) ->
      return if vm.subscribed
      SocketWrapper.subscribe($scope, channel, "update_fiat_transaction", (event, data) ->
        index = vm.fiatTransactions.findIndex ((output) -> output.id == data.id)
        oldFiatTransaction = vm.fiatTransactions[index]
        if oldFiatTransaction
          angular.extend(oldFiatTransaction, data)
        else
          return if vm.fiatTransactions.length > 0 && (data.id < vm.fiatTransactions[0].id)
          data.animateClass = "animate-row"
          vm.fiatTransactions.unshift data
      )
      vm.subscribed = true

    init()
    return


