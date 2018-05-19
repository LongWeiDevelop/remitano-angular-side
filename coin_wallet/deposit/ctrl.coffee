'use strict'

angular.module 'remitano'
.controller 'CoinWalletDepositController',
($scope, RAILS_ENV, AccountManager, CoinAccount, $rootScope, $translate, $timeout,
Flash, SocketWrapper, Auth, $stateParams) ->
  vm = @
  init = ->
    vm.errors = {}
    vm.coinAccount = -> AccountManager.depositCoinAccount()
    vm.minimumDeposit = RAILS_ENV.minimum_deposit
    vm.transactionFee = RAILS_ENV.transaction_fee
    vm.conversionFeePercent = "#{(RAILS_ENV.deposit_fee + RAILS_ENV.conversion_fee) * 100}%"
    vm.generateDepositAddress = generateDepositAddress
    # subscribeCoinAccountChannel()
    # scheduleLoadCoinAccount()

  subscribeCoinAccountChannel = () ->
    user_id = Auth.currentUser().id
    SocketWrapper.subscribePrivate user_id, $scope, AccountManager.coinAddressChannel(), "updated", loadCoinAccount

  loadCoinAccount = ->
    if vm.coinAccount().address
      clearInterval(vm.interval)
      return
    AccountManager.fetchCoinAccounts()

  scheduleLoadCoinAccount = ->
    vm.interval = setInterval(loadCoinAccount, 3000)

  handleAddressUpdated = ->
    loadCoinAccount()

  generateDepositAddress = ->
    return if vm.generating
    vm.generating = true
    CoinAccount.newDepositAddress(coin_currency: RAILS_ENV.coin_currency).$promise
      .then(onGenerateSuccess, onGenerateError)
      .finally ->
        vm.generating = false

  onGenerateSuccess = (coinAccounts) ->
    vm.depositAddressChanged = true
    AccountManager.assignNewCoinAccount(coinAccounts)
    scheduleLoadCoinAccount()

  onGenerateError = (response) ->
    Flash.displayError(response.data)

  init()
  return

