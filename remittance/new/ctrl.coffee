'use strict'

angular.module 'remitano'
.controller 'RemittanceNewController',
($scope, $stateParams, $translate, dialogs,
RemittancePreparator, Remittance,
RemittanceRateFormatter,
RAILS_ENV, CURRENCY_PRECISION, CountryNameTranslate) ->
  vm = @
  init = ->
    vm.remittance = newRemittance()
    vm.remittableCountries = calculateRemittableCountries()
    vm.estimateRemittanceAgain = estimateRemittanceAgain
    vm.requestRemittance = requestRemittance
    vm.sendingCurrency = RAILS_ENV.country_currencies[vm.remittance.from_country_code]

    $scope.$watch "vm.remittance.to_country_code", ->
      vm.receivingCurrency = RAILS_ENV.country_currencies[vm.remittance.to_country_code]
      estimateRemittance(vm.remittance.sending_amount)

    $scope.$watch "vm.remittance.sending_amount", ->
      estimateRemittance(vm.remittance.sending_amount)

    $scope.$watch "vm.estimation.receiving_amount", (amount) ->
      vm.receivingRate = RemittanceRateFormatter.format(vm.remittance, amount)

  newRemittance = ->
    if (remittance = RemittancePreparator.getRemittance())?
      RemittancePreparator.cleanUp()
      return remittance
    else
      coin_currency: RAILS_ENV.coin_currency
      from_country_code: $stateParams.country

  calculateRemittableCountries = ->
    codes = _.filter RAILS_ENV.countries, (code) -> code != vm.remittance.from_country_code
    for code in codes
      code: code
      name: CountryNameTranslate.instant(code)

  estimateRemittanceAgain = ->
    estimateRemittance(vm.remittance.sending_amount)

  estimateRemittance = (sendingAmount) ->
    vm.estimation = null
    vm.remittanceImpossible = false
    vm.estimatingFailed = false
    return unless sendingAmount?
    return unless sendingAmount > 0
    return unless vm.remittance.to_country_code?
    vm.estimating ||= 0
    vm.estimating += 1
    estimateSuccess = (estimation) ->
      if sendingAmount == vm.remittance.sending_amount
        vm.estimation = estimation
        vm.remittanceImpossible = !vm.estimation.receiving_amount?
    estimateFailed = ->
      if sendingAmount == vm.remittance.sending_amount
        vm.estimatingFailed = true

    Remittance.estimate(
      coin_currency: RAILS_ENV.coin_currency,
      from_country_code: vm.remittance.from_country_code,
      to_country_code: vm.remittance.to_country_code,
      sending_amount: sendingAmount
    ).$promise.then(estimateSuccess, estimateFailed).finally ->
      vm.estimating -= 1

  requestRemittance = (form)->
    return if form.$invalid
    return if vm.submitting
    title = $translate.instant("remittance_price_warning_title")
    body = $translate.instant("remittance_price_warning_body")
    dialogs.confirm(title, body).result.then ->
      vm.submitting = true
      RemittancePreparator.prepare(vm.remittance)

  init()
  return

