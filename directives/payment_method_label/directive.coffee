'use strict'

angular.module 'remitano'
.directive 'paymentMethodLabel', ->
  restrict: 'E'
  replace: true
  scope:
    method: "<"
  templateUrl: 'directives/payment_method_label/tmpl.html'
  controllerAs: 'vm'
  bindToController: true
  controller: ->
    vm = @
    vm.showBankName = !_.isEmpty(vm.method?.bank_name)
    return
