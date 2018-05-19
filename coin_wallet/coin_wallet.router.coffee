"use strict"

angular.module "remitano"
.config ($stateProvider, AccessLevels) ->
  $stateProvider
  .state "root.depositWithdrawRemi", #legacy route
    url: "/deposit_withdraw"
    template: ""
    controller: ($state) ->
      $state.go("root.coinWallet.withdrawal")
  .state "root.coinWallet",
    url: "/wallet/coin"
    abstract: true
    templateUrl: "coin_wallet/coin_wallet.tmpl.html"
    data:
      access: AccessLevels.user

  .state "root.coinWallet.withdrawal",
    url: "/withdrawal"
    templateUrl: "coin_wallet/withdrawal/template.tmpl.html"
    controller: "CoinWalletWithdrawalController"
    controllerAs: "vm"
    data:
      title: 'coin_wallet_withdrawal'
      access: AccessLevels.user

  .state "root.coinWallet.deposit",
    url: "/deposit"
    templateUrl: "coin_wallet/deposit/template.tmpl.html"
    controller: "CoinWalletDepositController"
    controllerAs: "vm"
    data:
      title: 'coin_wallet_deposit'
      access: AccessLevels.user

  .state "root.coinWallet.transactions",
    url: "/transactions"
    templateUrl: "coin_wallet/transactions/template.tmpl.html"
    controller: "CoinWalletTransactionsController"
    controllerAs: "vm"
    data:
      title: 'history'
      access: AccessLevels.user

  .state "root.coinWalletIntroduction",
    url: "/wallet/coin"
    templateUrl: "coin_wallet/introduction/template.tmpl.html"
    controller: "CoinWalletIntroductionController"
    controllerAs: "vm"
    data:
      title: 'coin_wallet_instruction_title'
