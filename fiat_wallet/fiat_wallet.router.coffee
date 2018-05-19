"use strict"

angular.module "remitano"
.config ($stateProvider, AccessLevels) ->
  $stateProvider
  .state "root.fiatWallet",
    url: "/wallet/fiat"
    abstract: true
    templateUrl: "fiat_wallet/fiat_wallet.tmpl.html"
    controller: "FiatWalletController"
    controllerAs: "fiatvm"
    data:
      access: AccessLevels.user

  .state "root.fiatWallet.withdrawal",
    url: "/withdrawal"
    templateUrl: "fiat_wallet/withdrawal/template.tmpl.html"
    controller: "FiatWalletWithdrawalController"
    controllerAs: "vm"
    data:
      title: 'fiat_wallet_withdrawal'
      access: AccessLevels.user

  .state "root.fiatWallet.deposit",
    url: "/deposit"
    templateUrl: "fiat_wallet/deposit/template.tmpl.html"
    controller: "FiatWalletDepositController"
    controllerAs: "vm"
    data:
      title: 'fiat_wallet_deposit'
      access: AccessLevels.user

  .state "root.fiatWallet.transactions",
    url: "/transactions"
    templateUrl: "fiat_wallet/transactions/template.tmpl.html"
    controller: "FiatWalletTransactionsController"
    controllerAs: "vm"
    data:
      title: 'history'
      access: AccessLevels.user
