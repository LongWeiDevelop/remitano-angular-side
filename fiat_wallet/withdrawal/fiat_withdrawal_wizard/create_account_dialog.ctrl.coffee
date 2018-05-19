'use strict'

angular.module 'remitano'
.controller 'createAccountDialogCtrl', ($uibModalInstance, RAILS_ENV,
FiatWithdrawalDetails, $translate, $state) ->
  vm = @

  init = ->
    vm.close = close
    vm.create = create
    vm.fiatWithdrawalDetails = { details: {} }
    vm.validateInput = validateInput
    vm.withdrawalMethod = RAILS_ENV.fiat_payment_method
    vm.autoBankAccountNumberInput = RAILS_ENV.fiat_payment_method.auto_populate_bank_account_name

  create = (form) ->
    form.$setDirty()
    form.$setSubmitted()
    return unless form.$valid
    vm.errorMessage = null
    form.submitting = true
    withdrawalDetailsParams = angular.merge(
      {fiat_withdrawal_details: vm.fiatWithdrawalDetails},
      {country_code: RAILS_ENV.current_country}
    )
    FiatWithdrawalDetails.save(withdrawalDetailsParams).$promise
      .then(createSuccess, createError)
      .finally(->
        form.submitting = false
      )

  createSuccess = (data) ->
    $uibModalInstance.close(data)
    if data.status == 'unconfirmed'
      $state.go("root.actionConfirmationConfirm", id: data.action_confirmation_id)

  createError = (res) ->
    vm.errorMessage = res.data?.error || $translate.instant("other_internal_server_error")

  close = ->
    $uibModalInstance.dismiss()


  validateInput = (form, inputName, error = null) ->
    return unless form
    input = form[inputName]
    return false unless form.$submitted
    if error == null
      return input.$invalid
    else
      return input.$error[error]

  init()
  return
