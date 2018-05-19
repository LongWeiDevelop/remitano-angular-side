'use strict'

angular.module 'remitano'
.directive "remittancePreDeposit", (Remittance, RemittanceRateFormatter, $q) ->
  restrict: "EA"
  scope:
    remittance: "<"
    onSelectDepositMethod: "&"
  controllerAs: "vm"
  bindToController: true
  templateUrl: "remittance/show/remittance_pre_deposit/tmpl.html"
  controller: ->
    vm = this
    init = ->
      vm.estimations = []
      vm.load = load
      vm.deposit = deposit
      vm.selectEstimation = selectEstimation
      load()

    selectEstimation = (estimation) ->
      vm.selectedEstimation = estimation

    deposit = ->
      vm.onSelectDepositMethod($method: vm.selectedEstimation.method)

    load = ->
      vm.loading = true
      vm.loadFailed = false
      Remittance.depositMethods(ref: vm.remittance.ref).
        $promise.then(storeDepositMethods, loadingFailed).finally -> vm.loading = false

    loadingFailed = -> vm.loadFailed = true

    storeDepositMethods = (methods) ->
      vm.estimations = for method in methods
        method: method
        fullMethodName: [method.name, method.bank_name].join("-")
        receivingAmount: method.receiving_amount
        receivingRate: RemittanceRateFormatter.format(vm.remittance, method.receiving_amount)
        offer: method.deposit_offer

    init()
    return
