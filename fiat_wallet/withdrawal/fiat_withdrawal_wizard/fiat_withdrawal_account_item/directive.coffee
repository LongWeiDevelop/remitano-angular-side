'use strict'

angular.module 'remitano'
.directive 'fiatWithdrawalAccountItem', ->
  restrict: 'E'
  replace: true
  scope:
    details: "<"
    onSelect: "&"
  templateUrl: 'fiat_wallet/withdrawal/fiat_withdrawal_wizard/fiat_withdrawal_account_item/tmpl.html'
  controllerAs: 'vm'
  bindToController: true
  controller: (FiatWithdrawalDetails) ->
    vm = this
    vm.length = Object.keys(vm.details.details).length
    vm.deleting = false

    vm.delete = ($event) ->
      $event.stopPropagation()
      FiatWithdrawalDetails.delete(id: vm.details.id).$promise.then -> vm.deleted = true

    vm.setDeleting = ($event, bool) ->
      $event.stopPropagation()
      vm.deleting = bool
    vm.onItemSelect = ->
      unless vm.deleted
        vm.onSelect({ $details: vm.details })
    return
