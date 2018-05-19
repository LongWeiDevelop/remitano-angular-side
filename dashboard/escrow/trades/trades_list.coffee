'use strict'

angular.module 'remitano'
.directive "tradesList", (RAILS_ENV) ->
  restrict: "E"
  replace: true
  scope:
    tradeStatus: "="
    tradeType: "@"
  templateUrl: "dashboard/escrow/trades/trades_list.tmpl.html"
  bindToController: true
  controllerAs: "vm"
  controller: ($scope, Trade) ->
    vm = this
    init = ->
      vm.loadTrades = loadTrades
      vm.pageChanged = pageChanged
      vm.loadTrades()

    loadTrades = (options = {}) ->
      vm.fetchingTrades = true

      loadTradeSuccess = (data) ->
        vm.fetchingTrades = false
        vm.tradesWithRoles = data.trades
        vm.paginationMeta = data.meta

      loadTradeError = ->
        vm.fetchingTrades = false
        vm.errorFetchingTrades = true

      filter =
        coin_currency: RAILS_ENV.coin_currency
        trade_status: vm.tradeStatus
        trade_type: vm.tradeType
      Trade.query(angular.extend(filter, options), loadTradeSuccess, loadTradeError)

    pageChanged = (toPage) ->
      loadTrades(page: toPage)

    init()
    return
