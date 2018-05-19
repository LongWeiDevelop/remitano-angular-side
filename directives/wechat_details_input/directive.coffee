'use strict'

angular.module 'remitano'
.directive 'wechatDetailsInput', () ->
  restrict: 'E'
  templateUrl: 'directives/wechat_details_input/tmpl.html'
  require: ['^form']
  scope:
    paymentDetails: "<"
  controllerAs: 'vm'
  bindToController: true
  controller: ->
    return
  link: (scope, element, attr, [form]) ->
    scope.form = form
