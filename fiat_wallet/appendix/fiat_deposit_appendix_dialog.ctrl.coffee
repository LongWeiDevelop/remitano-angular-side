'use strict'

angular.module 'remitano'
.controller 'fiatDepositAppendixDialogCtrl', ($scope, $uibModalInstance, $q, fiatDeposit, appendix, requiredAppendixFields, FiatDeposit, RAILS_ENV, $templateCache) ->
  vm = this
  init = ->
    vm.fiatDeposit = fiatDeposit
    vm.appendix = angular.copy(appendix)
    vm.requiredAppendixFields = requiredAppendixFields
    vm.validateInput = validateInput
    vm.submit = submit
    vm.appendixRegexes = {
      transaction_reference_number: /(\d{12}|[a-zA-Z]{4}(R|r)\d{18})/
    }
    vm.isExpTemplateExist = isExpTemplateExist
    vm.getExpTemplatePath = getExpTemplatePath
    if vm.fiatDeposit.country_code == "vn"
      vm.appendix.bank_name = "Vietcombank"
      initVcbPaymentOptions()
      watchVcbPayVia()

  watchVcbPayVia = ->
    $scope.$watch "vm.appendix.pay_via", (pay_via) ->
      vm.vcbExtraFieldName = switch pay_via
        when "ibanking", "cash_deposit" then "payment_receipt"
        when "mobile_banking" then "bank_account_number"
        when "bank_plus" then "sending_phone_number"
        else null

      vm.vcbExtraFieldType = switch vm.vcbExtraFieldName
        when null then null
        when "payment_receipt" then "image"
        else "text"

  initVcbPaymentOptions = ->
    vm.vcbPaymentOptions = [
      'ibanking'
      'mobile_banking'
      'bank_plus'
      'cash_deposit'
    ]

  isExpTemplateExist = (name) ->
    if $templateCache.get(getExpTemplatePath(name))
      return true
    else
      return false

  getExpTemplatePath = (name) ->
    "fiat_wallet/appendix/#{name}_explanation.tmpl.html"

  validateInput = (form, inputName, error = null) ->
    return unless form
    input = form[inputName]
    return false unless form.$submitted
    if error == null
      return input.$invalid
    else
      return input.$error[error]

  vm.close = ->
    $uibModalInstance.dismiss('close')
    return

  submit = ->
    form = vm.appendixForm
    form.$setDirty()
    form.$setSubmitted()
    return unless form.$valid
    vm.submitting = true
    vm.message = null
    FiatDeposit.submitAppendix({
      appendix: vm.appendix
      country_code: RAILS_ENV.current_country
      id: vm.fiatDeposit.id
    }).$promise.then(submitSuccess, submitError)
    .finally ->
      vm.submitting = false
    return

  submitSuccess = (fiatDeposit) ->
    $uibModalInstance.close(fiatDeposit)

  submitError = (res) ->
    vm.message = res.data.error

  init()
  return


