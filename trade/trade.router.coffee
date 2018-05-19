'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider.state 'root.tradeCreate',
    url: '/trades/create'
    templateUrl: 'trade/trade_create/tmpl.html'
    controller: "TradeCreateController"
    controllerAs: "vm"
    data:
      access: AccessLevels.user
      noSEO: true
      title: 'create_trade_title'
  .state 'root.trade',
    url: '/trades/:ref'
    templateUrl: 'trade/trade.tmpl.html'
    controller: "TradeController"
    controllerAs: "vm"
    data:
      access: AccessLevels.user
      title: 'main_title_trade'
