'use strict'

angular.module 'remitano'
.directive "fiatWithdrawalConfirm", ->
  restrict: "E"
  templateUrl: "fiat_wallet/withdrawal/fiat_withdrawal_wizard/fiat_withdrawal_confirm.tmpl.html"
  controllerAs: "vm"
  scope:
    fiatWithdrawal: "="
    onConfirmFiatWithdrawal: "&"
    onReset: "&"
  bindToController: true
  controller: (RAILS_ENV, FiatWithdrawal, Flash, $state, dialogs, $translate) ->
    vm = @

    init = ->
      vm.currency = RAILS_ENV.current_currency
      vm.confirmWithdrawal = confirmWithdrawal
      vm.resetWithdrawal = resetWithdrawal

    confirmWithdrawal = ->
      submitFiatWithdrawal()

    resetWithdrawal = ->
      vm.onReset()

    submitFiatWithdrawal = ->
      vm.submitting = true
      fiatWithdrawal =
        country_code: RAILS_ENV.current_country
        fiat_withdrawal_detail_id: vm.fiatWithdrawal.account.id
        fiat_withdrawal:
          fiat_amount: vm.fiatWithdrawal.fiat_amount

      FiatWithdrawal.save(fiatWithdrawal).$promise
        .then(onSubmitSuccess, onSubmitError)
        .finally( ->
          vm.submitting = false
        )

    onSubmitSuccess = (data) ->
      vm.fiatWithdrawal = {}
      vm.submitting = false
      $state.go("root.actionConfirmationConfirm", id: data.id)

    onSubmitError = (response) ->
      dialogs.error($translate.instant("DIALOGS_ERROR"), response.data?.error || $translate.instant("other_internal_server_error"))

    init()
    return

