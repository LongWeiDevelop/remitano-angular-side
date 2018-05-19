'use strict'

angular.module 'remitano'
.directive 'preTradeWarnings', (Auth, User, FiatDeposit, RAILS_ENV) ->
  restrict: 'E'
  templateUrl: 'directives/pre_trade_warnings/tmpl.html'
  scope:
    offer: "<"
    isRemittance: "<"
    onDismiss: "&"
  controllerAs: 'vm'
  bindToController: true
  controller: ($scope, $filter) ->
    vm = this
    init = ->
      vm.warnings = []
      calculateWarnings()
      shiftFirstWarning()
      vm.dismissCurrentWarning = shiftFirstWarning
      vm.paymentWindow = vm.offer?.payment_time
      vm.customPrefix = if vm.isRemittance then "remittance_" else ""

    onFetchDepositDetailsSuccess = (data) ->
      vm.fiatDepositDetails = data.fiat_deposit_details

    onFetchDepositDetailsError = (err) ->
      vm.errorFetchingFiatDepositDetails = true
      vm.errorFetchingFiatDepositMessage = err.data?.error || $translate.instant("other_something_went_wrong")

    calculateWarnings = ->
      if (twarnings = vm.offer?.taker_warnings)
        addWarning(warning) for warning in twarnings

    addWarning = (warning) ->
      if (swarnings = Auth.currentUser()?.seen_warnings)
        return if swarnings[warning]?
      return if vm.isRemittance && warning == "do_not_mention_bitcoin"
      vm.warnings.push warning

    shiftFirstWarning = ->
      if vm.currentWarning
        markAsSeen(vm.currentWarning)
      vm.currentWarning = vm.warnings.shift()
      unless vm.currentWarning?
        vm.onDismiss()

    markAsSeen = (warning) ->
      User.markWarningAsSeen(warning: warning)

    init()
    return
