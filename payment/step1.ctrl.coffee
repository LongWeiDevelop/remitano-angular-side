'use strict'

angular.module 'remitano'
.controller 'PaymentStep1Controller',
($stateParams, $state, $cookies, RAILS_ENV, Auth, AccountManager, PaymentOperation, Flash) ->
  vm = @
  init = ->
    if _.isEmpty($stateParams.payment) && ($cookies.payment == undefined || $cookies.payment == null)
      return $state.go("root.home")

    if _.isEmpty($stateParams.payment)
      vm.payment = JSON.parse(unescape($cookies.payment))
    else
      vm.payment = $stateParams.payment

    vm.submitPayment = submitPayment
    vm.Auth = Auth
    vm.AccountManager = AccountManager
    vm.isReady = isReady
    vm.loginToPay = loginToPay
    delete $cookies["payment"]

  isReady = ->
    Auth.isLoggedIn()

  loginToPay = ->
    Auth.setAfterLoginState($state.$current.name, payment: vm.payment)
    $state.go('root.login')

  submitPayment = ->
    vm.submitting = true

    submitPaymentSuccess = (confirmationAction) ->
      $state.go("root.actionConfirmationConfirm", id: confirmationAction.id)

    submitPaymentError = (error)->
      Flash.displayError(error.data)
      vm.submitting = false

    PaymentOperation.save(payment: vm.payment, submitPaymentSuccess, submitPaymentError)

  init()
