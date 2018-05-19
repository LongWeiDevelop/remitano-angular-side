'use strict'

angular.module('remitano')
.factory 'MobileMenu', ($state, $stateParams, Auth, $translate, RAILS_ENV) ->
  MobileMenu =
    getItems: ->
      items = []

      items.push
        isCategory: false
        text: $translate.instant('menu_trade_coin')
        sref: 'root.landing'
        appIcon: 'home'

      unless RAILS_ENV.remittance_disabled[$stateParams.country]
        items.push
          isCategory: false
          text: $translate.instant('remittance')
          sref: 'root.remittance.new'
          appIcon: 'paper-plane-o'

      items.push
        isCategory: false
        hide: Auth.isLoggedIn()
        text: $translate.instant('login_or_register')
        sref: 'root.login'
        icon: 'root.landing'
        appIcon: 'user'
      items.push
        isCategory: true
        hide: !Auth.isLoggedIn()
        text: $translate.instant('dashboard_dashboard')
        items: [
          {
            sref: 'root.dashboard.escrow.trades({"tradeStatus": "active"})'
            icon: 'icon-clock'
            appIcon: 'clock-o'
            text: $translate.instant('dashboard_escrow_active_trades')
          }
          {
            sref: 'root.dashboard.escrow.trades({"tradeStatus": "closed"})'
            icon: 'icon-check'
            appIcon: 'check-square'
            text: $translate.instant('dashboard_escrow_closed_trades')
          }
          {
            sref: 'root.dashboard.escrow.offers'
            icon: 'icon-bullhorn'
            appIcon: 'bullhorn'
            text: $translate.instant('dashboard_escrow_offers')
          }
        ]
      items.push
        isCategory: true
        hide: !Auth.isLoggedIn()
        text: $translate.instant('menu_coin_wallet')
        items: [
          {
            sref: 'root.coinWallet.withdrawal'
            icon: 'icon-paper-plane-empty'
            appIcon: 'paper-plane-o'
            text: $translate.instant('coin_wallet_withdrawal')
          }
          {
            sref: 'root.coinWallet.deposit'
            icon: 'icon-download'
            appIcon: 'download'
            text: $translate.instant('coin_wallet_deposit')
          }
          {
            sref: 'root.coinWallet.transactions'
            icon: 'icon-docs'
            appIcon: 'history'
            text: $translate.instant('history')
          }
        ]
      items.push
        isCategory: true
        hide: !Auth.isLoggedIn() || (!Auth.hasFiatWallet() && !RAILS_ENV.fiat_wallet)
        text: $translate.instant('menu_fiat_wallet', currency: RAILS_ENV.current_currency)
        items: [
          {
            sref: 'root.fiatWallet.deposit'
            icon: 'icon-download'
            appIcon: 'download'
            text: $translate.instant('fiat_wallet_deposit')
          }
          {
            sref: 'root.fiatWallet.withdrawal'
            icon: 'icon-paper-plane-empty'
            appIcon: 'paper-plane-o'
            text: $translate.instant('fiat_wallet_withdrawal')
          }
          {
            sref: 'root.fiatWallet.transactions'
            icon: 'icon-docs'
            appIcon: 'history'
            text: $translate.instant('history')
          }
        ]
      items.push
        isCategory: false
        hide: !Auth.isLoggedIn()
        text: $translate.instant('header_settings')
        sref: 'root.settings'
        icon: 'icon-cog'
        appIcon: 'cog'
      items.push
        isCategory: false
        hide: !Auth.isLoggedIn()
        text: $translate.instant('header_logout')
        sref: 'root.logout'
        icon: 'icon-logout'
        appIcon: 'sign-out'

      items
