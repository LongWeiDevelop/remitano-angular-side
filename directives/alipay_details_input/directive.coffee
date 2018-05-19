'use strict'

angular.module 'remitano'
.directive 'alipayDetailsInput', () ->
  restrict: 'E'
  templateUrl: 'directives/alipay_details_input/tmpl.html'
  require: ['^form']
  scope:
    paymentDetails: "<"
  controllerAs: 'vm'
  bindToController: true
  controller: ->
    vm = this
    vm.isDetailsInvalid = ->
      return false if vm.paymentDetails.alipay_qr_url?
      return true unless vm.paymentDetails.alipay_email?
      _.trim(vm.paymentDetails.alipay_email).length == 0

    vm.isDetailsValid = ->
      !vm.isDetailsInvalid()
    return

  link: (scope, element, attr, [form]) ->
    scope.form = form
