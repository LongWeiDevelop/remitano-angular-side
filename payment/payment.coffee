'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider
  .state 'root.payment',
    abstract: true
    templateUrl: 'payment/payment.tmpl.html'
    data:
      title: 'payment_title'
  .state 'root.payment.step1',
    url: '/payment/step1'
    templateUrl: 'payment/step1.tmpl.html'
    data:
      title: 'payment_title'
    params:
      payment: {}
    controller: 'PaymentStep1Controller as vm'
