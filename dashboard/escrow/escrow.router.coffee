'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider
  .state 'root.dashboard.escrow',
    abstract: true
    templateUrl: 'dashboard/escrow/escrow.tmpl.html'
  .state 'root.dashboard.escrow.offers',
    url: '/dashboard/escrow/offers'
    controller: 'DashboardEscrowOffersController'
    controllerAs: 'vm'
    templateUrl: 'dashboard/escrow/offers/offers.tmpl.html'
    data:
      title: 'main_title_dashboard_escrow_offers'
      access: AccessLevels.user
  .state 'root.dashboard.escrow.trades',
    url: '/dashboard/escrow/trades/:tradeStatus'
    controller: "DashboardEscrowTradesController"
    templateUrl: 'dashboard/escrow/trades/trades.tmpl.html'
    controllerAs: 'vm'
    data:
      title: 'main_title_dashboard_escrow_trades'
      head:
        canonical: "/dashboard/escrow/trades/active"
        access: AccessLevels.user
