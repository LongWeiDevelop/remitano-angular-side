'use strict'

angular.module 'remitano'
.directive "remittanceItem", ->
  restrict: "EA"
  scope:
    remittance: "="
  controllerAs: "vm"
  bindToController: true
  templateUrl: "remittance/history/remittance_item/tmpl.html"
  controller: ->
    vm = this
    init = ->
      vm.colorClass = switch vm.remittance.status
        when "withdraw_released" then "success"
        when "deposit_disputed", "withdraw_disputed" then "danger"
        when "pending", "deposit_cancelled" then "default"
        else "warning"

    init()
    return
