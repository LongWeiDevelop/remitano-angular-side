'use strict'

angular.module 'remitano'
.controller 'RemittanceShowController', ($stateParams, Remittance, DynamicTitle, Flash) ->
  vm = @
  init = ->
    vm.ref = $stateParams.ref
    DynamicTitle.setTranslated(vm.ref)
    vm.fetchRemittance = fetchRemittance
    vm.requestDeposit = requestDeposit
    vm.requestWithdraw = requestWithdraw
    fetchRemittance()

  requestSuccess = (newRemittance) ->
    vm.remittance = newRemittance

  requestError = (res) ->
    Flash.displayError(res.data)

  requestDeposit = (method) ->
    vm.fetching = true
    Remittance.requestDeposit(ref: vm.ref, payment_method: method.name, bank_name: method.bank_name).
      $promise.then(requestSuccess, requestError).finally -> vm.fetching = false

  requestWithdraw = (method, paymentDetails) ->
    vm.fetching = true
    Remittance.requestWithdraw(
      ref: vm.ref,
      payment_method: method.name,
      bank_name: method.bank_name,
      payment_details: paymentDetails
    ).$promise.then(requestSuccess, requestError).finally -> vm.fetching = false

  fetchRemittanceError = ->
    vm.fetchError = true

  fetchRemittanceSuccess = (remittance) ->
    vm.remittance = remittance

  fetchRemittance = ->
    vm.fetching = true
    Remittance.get(ref: vm.ref).$promise.then(fetchRemittanceSuccess, fetchRemittanceError).finally -> vm.fetching = false

  init()
  return
