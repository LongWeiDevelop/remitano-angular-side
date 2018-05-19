'use strict'

angular.module 'remitano'
.controller 'FiatWalletDepositController',
($scope, $interval, RAILS_ENV, CURRENCY_PRECISION, FiatDeposit, Flash, SocketWrapper, Auth, $uibModal) ->
  vm = @
  init = ->
    vm.currentFiatDeposit = null
    vm.receiptUloadSuccessFlag = false
    vm.currency = RAILS_ENV.current_currency
    vm.maxDecimals = CURRENCY_PRECISION[vm.currency]
    vm.country_code = RAILS_ENV.current_country
    vm.generateFiatDeposit = generateFiatDeposit
    vm.minFiatAmount = RAILS_ENV.fiat_payment_method?.transaction_limit?.min
    vm.maxFiatAmount = RAILS_ENV.fiat_payment_method?.transaction_limit?.max
    vm.fetchCurrentFiatDeposit = fetchCurrentFiatDeposit
    vm.cancelFiatDeposit = cancelFiatDeposit
    vm.onReceiptUploadSuccess = onReceiptUploadSuccess
    vm.hasAppendix = hasAppendix
    vm.showDelayMessage = showDelayMessage
    fetchCurrentFiatDeposit()

  showDelayMessage = ->
    return false unless vm.currentFiatDeposit.bank_corp
    d = new Date()
    n = d.getHours()
    (n >= 22 || d < new Date().setHours(23, 59, 59, 999)) && vm.country_code == 'vn'

  hasAppendix = ->
    if vm.currentFiatDeposit?.required_appendix_fields && vm.currentFiatDeposit?.required_appendix_fields?.length > 0
      return true
    else
      return false

  loadFiatDeposit = ->
    return unless vm.currentFiatDeposit
    FiatDeposit.get(id: vm.currentFiatDeposit.id, country_code: vm.country_code).$promise
      .then(getFiatDepositSuccess, getFiatDepositError)

  getFiatDepositError = ->
    unless vm.currentFiatDeposit?.status == 'ready'
      setTimeout loadFiatDeposit, 3000

  getFiatDepositSuccess = (data) ->
    handleFiatDepositUpdated({}, data)
    unless vm.currentFiatDeposit?.status == 'ready'
      setTimeout loadFiatDeposit, 3000

  subscribeFiatDepositChannel = (id) ->
    user_id = Auth.currentUser().id
    SocketWrapper.subscribe $scope, "private-user_#{user_id}@fiat_deposit_channel_#{id}", "updated", handleFiatDepositUpdated
    loadFiatDeposit()

  unSubscribeFiatDepositChannel = (id) ->
    user_id = Auth.currentUser().id
    SocketWrapper.subscribe $scope, "private-user_#{user_id}@fiat_deposit_channel_#{id}", "updated"

  handleFiatDepositUpdated = (event, data) ->
    handleFiatDepositStatus(data)

  handleFiatDepositStatus = (fiatDeposit) ->
    vm.currentFiatDeposit = fiatDeposit
    if !vm.currentFiatDeposit || vm.currentFiatDeposit.status == 'cancelled' || vm.currentFiatDeposit.status == 'processed'
      unSubscribeFiatDepositChannel(vm.currentFiatDeposit.id) if vm.currentFiatDeposit
      if vm.currentFiatDeposit?.cancel_reason
        Flash.add("danger", vm.currentFiatDeposit.cancel_reason)

      vm.currentFiatDeposit = null
      vm.loading = false
      vm.showFiatDepositList = true
    else if vm.currentFiatDeposit.status == 'ready'
      vm.loading = false
    else if vm.currentFiatDeposit.status == 'pending'
      vm.loading = true

  fetchCurrentFiatDeposit = ->
    vm.loading = true
    vm.errorFetchingCurrentFiatDeposit = false
    FiatDeposit.currentFiatDeposit({country_code: vm.country_code}).$promise
      .then(onFetchCurrentFiatDepositSuccess, onFetchCurrentFiatDepositError)
      .finally ->
        handleFiatDepositStatus(vm.currentFiatDeposit)
        subscribeFiatDepositChannel(vm.currentFiatDeposit?.id)

  onFetchCurrentFiatDepositError = ->
    vm.errorFetchingCurrentFiatDeposit = true

  onFetchCurrentFiatDepositSuccess = (data) ->
    unless data.id
      vm.currentFiatDeposit = null
    else
      vm.currentFiatDeposit = data

  generateFiatDeposit = (form) ->
    return unless form.$valid
    return if vm.generating
    vm.generating = true
    vm.showFiatDepositList = false
    vm.fiatDeposit.country_code = vm.country_code
    FiatDeposit.save(vm.fiatDeposit).$promise
      .then(onGenerateSuccess, onGenerateError)
      .finally ->
        vm.generating = false
        handleFiatDepositStatus(vm.currentFiatDeposit)
        subscribeFiatDepositChannel(vm.currentFiatDeposit?.id)

  onGenerateSuccess = (fiatDeposit) ->
    vm.currentFiatDeposit = fiatDeposit

  onGenerateError = (response) ->
    Flash.displayError(response.data)

  cancelFiatDeposit = ->
    res = new FiatDeposit(vm.currentFiatDeposit)
    res.$cancelFiatDeposit({country_code: vm.country_code}, cancelSuccess, cancelError)

  onReceiptUploadSuccess = ->
    vm.receiptUloadSuccessFlag = true
    # Workaround $timeout: https://github.com/angular/protractor/issues/169
    $interval (->
      vm.receiptUloadSuccessFlag = false
    ), 5000, 1

  cancelSuccess = ->
    vm.currentFiatDeposit = null

  cancelError = (res) ->
    Flash.displayError(res.data)

  init()
  return
