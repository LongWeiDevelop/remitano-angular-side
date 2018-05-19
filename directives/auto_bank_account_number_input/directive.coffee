'use strict'

angular.module 'remitano'
.directive 'autoBankAccountNumberInput', ->
  restrict: 'E'
  templateUrl: 'directives/auto_bank_account_number_input/tmpl.html'
  require: ["?^hasErrorFor", "^form"]
  scope:
    paymentDetails: "<"
  controllerAs: 'vm'
  bindToController: true
  link: (scope, element, attrs, [hasErrorForCtrl, ngFormCtrl]) ->
    scope.vm.hasErrorForCtrl = hasErrorForCtrl
    scope.vm.ngFormCtrl = ngFormCtrl

  controller: ($scope, AccountManager, $http, $stateParams, RAILS_ENV) ->
    vm = this
    init = ->
      vm.fetchAccountName = fetchAccountName
      vm.accountFetchTimes = {}
      vm.pattern = RAILS_ENV.fiat_payment_method.bank_account_number_format
      vm.patternRegex = if vm.pattern? then new RegExp("^#{vm.pattern}$") else null
      fetchAccountName()

    fetchAccountName = (refetch = false) ->
      # show has-warning or has-success on parent hasErrorFor element
      vm.hasErrorForCtrl?.success = (vm.outcomeSuccess = false)
      vm.hasErrorForCtrl?.warning = (vm.outcomeError = false)

      return unless vm.paymentDetails?.bank_account_number?
      return if (vm.pattern?) && !(new RegExp(vm.pattern).test(vm.paymentDetails.bank_account_number))
      vm.fetchingAccountCount ||= 0
      vm.fetchingAccountCount += 1
      accountNumber = vm.paymentDetails.bank_account_number
      params =
        country_code: $stateParams.country
        bank_account_number: accountNumber
      if refetch
        vm.accountFetchTimes[accountNumber] = 0
        params.refetch = true

      url = "/api/v1/fiat_bank_accounts"
      $http.get(url, params: params).then(fetchAccountNameSuccess, (-> fetchAccountNameError(accountNumber))).finally ->
        vm.fetchingAccountCount -= 1

    setTransferable = (transferable) ->
      vm.ngFormCtrl["payment_details.bank_account_number"].$setValidity("transferable", transferable != false)
      if transferable == false
        vm.hasErrorForCtrl?.success = false
        vm.hasErrorForCtrl?.warning = true

    fetchAccountNameSuccess = (response) ->
      bankAccount = response.data
      accountNumber = bankAccount.bank_account_number
      return if bankAccount.bank_account_number != vm.paymentDetails.bank_account_number
      vm.accountFetchTimes[accountNumber] ||= 0
      vm.accountFetchTimes[accountNumber] += 1
      switch bankAccount.status
        when "fetched"
          vm.paymentDetails.bank_account_name = bankAccount.bank_account_name
          vm.paymentDetails.auto_populated = true
          vm.hasErrorForCtrl?.success = (vm.outcomeSuccess = true)
          setTransferable(bankAccount.transferable)
        when "error"
          vm.paymentDetails.auto_populated = false
          vm.hasErrorForCtrl?.warning = (vm.outcomeError = true)
          setTransferable(bankAccount.transferable)
        else
          setTransferable(true)
          vm.paymentDetails.auto_populated = false
          if vm.accountFetchTimes[accountNumber] < 10
            # avoid blinking in loading icon
            vm.fetchingAccountCount += 1
            interval = if RAILS_ENV.env == "test" then 1000 else 2000
            setTimeout (->
              fetchAccountName()
              vm.fetchingAccountCount -= 1
            ), interval
          else
            fetchAccountNameError(accountNumber)

    fetchAccountNameError = (accountNumber) ->
      return unless vm.paymentDetails.bank_account_number == accountNumber
      vm.hasErrorForCtrl?.warning = (vm.outcomeError = true)

    init()
    return
