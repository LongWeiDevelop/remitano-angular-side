'use strict'

angular.module 'remitano'
.directive "remittancePreWithdraw", (Remittance, RemittanceRateFormatter, $q) ->
  restrict: "EA"
  scope:
    remittance: "<"
    onSelectWithdrawMethod: "&"
  controllerAs: "vm"
  bindToController: true
  templateUrl: "remittance/show/remittance_pre_withdraw/tmpl.html"
  controller: ->
    vm = this
    init = ->
      vm.estimations = []
      vm.load = load
      vm.selectEstimation = selectEstimation
      vm.withdrawWith = withdrawWith
      load()

    selectEstimation = (estimation) ->
      vm.selectedEstimation = estimation

    withdrawWith = (paymentDetails) ->
      vm.onSelectWithdrawMethod($method: vm.selectedEstimation.method, $paymentDetails: paymentDetails)

    load = ->
      vm.loading = true
      vm.loadFailed = false
      Remittance.withdrawMethods(ref: vm.remittance.ref).
        $promise.then(storeWithdrawMethods, loadingFailed).finally -> vm.loading = false

    loadingFailed = -> vm.loadFailed = true

    storeWithdrawMethods = (methods) ->
      vm.estimations = for method in methods
        method: method
        fullMethodName: [method.name, method.bank_name].join("-")
        receivingAmount: method.receiving_amount
        receivingRate: RemittanceRateFormatter.format(vm.remittance, method.receiving_amount)
        offer: method.withdraw_offer

    init()
    return
