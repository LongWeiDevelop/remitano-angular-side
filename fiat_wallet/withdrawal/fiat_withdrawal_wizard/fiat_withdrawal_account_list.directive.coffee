'use strict'

angular.module 'remitano'
.directive "fiatWithdrawalAccountList", ->
  restrict: "E"
  templateUrl: "fiat_wallet/withdrawal/fiat_withdrawal_wizard/fiat_withdrawal_account_list.tmpl.html"
  controllerAs: "vm"
  scope:
    onAccountSelect: "&"
  bindToController: true
  controller: (dialogs, FiatWithdrawalDetails, RAILS_ENV) ->
    vm = @

    init = ->
      vm.openCreateAccountForm = openCreateAccountForm
      vm.fetchAccountList = fetchAccountList
      vm.selectAccount = selectAccount
      fetchAccountList()

    selectAccount = (account) ->
      vm.onAccountSelect($account: account)

    fetchAccountList = ->
      vm.fetching = true
      vm.fetchError = false
      FiatWithdrawalDetails.query({country_code: RAILS_ENV.current_country}).$promise
        .then(onFetchSuccess, onFetchError)
        .finally( ->
          vm.fetching = false
        )

    onFetchError = (data) ->
      vm.fetchError = true

    onFetchSuccess = (data) ->
      vm.fiatWithdrawalDetails = data

    openCreateAccountForm = ->
      dialogs.create("fiat_wallet/withdrawal/fiat_withdrawal_wizard/create_account_dialog.tmpl.html",
        "createAccountDialogCtrl", {}, {size: "md"}, "vm").result
      .then(onCreateSuccess)

    onCreateSuccess = (data) ->
      vm.fiatWithdrawalDetails.unshift(data)

    init()
    return

