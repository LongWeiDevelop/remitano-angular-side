'use strict'

angular.module 'remitano'
.directive "fiatWithdrawalList", (FiatWithdrawal, ObjectLiveUpdater, RAILS_ENV, $rootScope, dialogs, $translate, $state) ->
  restrict: "E"
  templateUrl: "fiat_wallet/withdrawal/fiat_withdrawal_list.tmpl.html"
  controllerAs: "vm"
  scope: {}
  controller: () ->
    vm = this

    init = ->
      vm.currentPage = 1
      vm.pageChanged = loadFiatWithdrawals
      vm.currency = RAILS_ENV.current_currency
      vm.country_code = RAILS_ENV.current_country
      vm.fiatWithdrawalStatusClass = fiatWithdrawalStatusClass
      vm.cancelFiatWithdrawal = cancelFiatWithdrawal
      vm.confirmFiatWithdrawal = confirmFiatWithdrawal
      loadFiatWithdrawals()
      $rootScope.$on "fiat_withdrawals.reload", loadFiatWithdrawals

    fiatWithdrawalStatusClass = (status) ->
      switch status
        when "delivered" then "badge-success"
        when "cancelled" then ""
        when "error" then "badge-danger"
        else "badge-warning"

    loadFiatWithdrawals = (page) ->
      vm.fetching = true
      vm.errorFetching = false
      loadSuccess = (data) =>
        vm.fiatWithdrawals = data.fiat_withdrawals
        ObjectLiveUpdater.singleton("fiat_withdrawal").clear().addAll(vm.fiatWithdrawals)
        vm.paginationMeta = data.meta

      loadError = (response) =>
        vm.errorFetching = true

      FiatWithdrawal.get(page: page, country_code: vm.country_code).$promise.
        then(loadSuccess, loadError).
        finally ->
          vm.fetching = false

    cancelFiatWithdrawal = (e, fiatWithdrawal) ->
      e.preventDefault()
      cancelSuccess = (data) ->
        angular.extend(fiatWithdrawal, data)

      cancelError = (response) ->
        dialogs.error($translate.instant("other_error"),
          $translate.instant(response.data?.key) || $translate.instant("other_internal_server_error"))

      FiatWithdrawal.cancel({id: fiatWithdrawal.id, country_code: vm.country_code}, cancelSuccess, cancelError)

    confirmFiatWithdrawal = (e, fiatWithdrawal) ->
      e.preventDefault()
      $state.go("root.actionConfirmationConfirm", id: fiatWithdrawal.action_confirmation?.id)

    init()
    return

