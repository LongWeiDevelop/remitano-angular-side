'use strict'

angular.module 'remitano'
.directive "fiatDepositList", (FiatDeposit, RAILS_ENV) ->
  restrict: "E"
  templateUrl: "fiat_wallet/deposit/fiat_deposit_list.tmpl.html"
  controllerAs: "vm"
  scope: {}
  controller: () ->
    vm = this

    init = ->
      vm.pageChanged = loadFiatDeposits
      vm.currency = RAILS_ENV.current_currency
      vm.country_code = RAILS_ENV.current_country
      vm.fiatDepositStatusClass = fiatDepositStatusClass
      loadFiatDeposits(true)

    fiatDepositStatusClass = (status) ->
      klazz = if status == "processed" || status == "approved"
        "badge-success"
      else if status == "pending" || status == "ready"
        "badge-warning"
      else
        "badge-danger"
      klazz += " #{status}"

    loadFiatDeposits = (page) ->
      vm.fetching = true
      vm.errorFetching = false
      loadSuccess = (data) =>
        vm.fiatDeposits = data.fiat_deposits
        vm.paginationMeta = data.meta
        vm.fetching = false

      loadError = (response) =>
        vm.errorFetching = true
        vm.fetching = false
      FiatDeposit.get {page: page, country_code: vm.country_code}, loadSuccess, loadError

    init()
    return
