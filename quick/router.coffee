'use strict'

angular.module 'remitano'
.config ($stateProvider) ->
  $stateProvider
  .state 'root.quickBuy',
    url: '/quick-buy'
    template: ""
    controller: ($state) ->
      $state.go("root.quick.buy")
    data:
      noSEO: true
  .state 'root.quickSell',
    url: '/quick-sell'
    template: ""
    controller: ($state) ->
      $state.go("root.quick.sell")
    data:
      noSEO: true

  .state "root.quick",
    url: "/quick"
    abstract: true
    templateUrl: "quick/layout.tmpl.html"

  .state "root.quick.buy",
    url: "/buy-bitcoin"
    templateUrl: 'quick/trade/quick_trade.tmpl.html'
    controller: 'QuickTradeController as vm'
    resolve:
      mode: -> "buy"

  .state 'root.quick.sell',
    url: '/sell-bitcoin'
    templateUrl: 'quick/trade/quick_trade.tmpl.html'
    controller: 'QuickTradeController as vm'
    resolve:
      mode: -> "sell"

