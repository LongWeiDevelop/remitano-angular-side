'use strict'

angular.module 'remitano'
.directive 'fiatAmount', (CURRENCY_PRECISION) ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/fiat_amount/tmpl.html'
  scope:
    amount: "<"
    currency: "<"
  controllerAs: 'vm'
  bindToController: true
  controller: ($scope) ->
    vm = this
    init = ->
      $scope.$watch "amount", recalculateFormattedAmount
      $scope.$watch "currency", recalculateFormattedAmount

    calculateFormattedAmount = ->
      return unless vm.amount?
      [vm.amount.floor(vm.precision).formatCurrency(vm.precision), vm.currency].join(" ")

    recalculateFormattedAmount = ->
      vm.precision = CURRENCY_PRECISION[vm.currency]
      vm.formattedAmount = calculateFormattedAmount()

    init()
    return
