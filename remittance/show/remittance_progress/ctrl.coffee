'use strict'

angular.module 'remitano'
.directive "remittanceProgress", ->
  restrict: "EA"
  scope:
    remittance: "<"
  controllerAs: "vm"
  bindToController: true
  templateUrl: "remittance/show/remittance_progress/tmpl.html"
  controller: ($scope, CountryNameTranslate) ->
    vm = this
    init = ->
      $scope.$watch "vm.remittance.status", recalculateRemittanceIndicators
      recalculateRemittanceIndicators()

    recalculateRemittanceIndicators = ->
      vm.remittanceIcon = calculateRemittanceIcon()
      vm.remittanceIconColorClass = calculateRemittanceIconColorClass()
      vm.toCountryValues =
        country: CountryNameTranslate.instant(vm.remittance?.to_country_code)
      vm.fromCountryValues =
        country: CountryNameTranslate.instant(vm.remittance?.from_country_code)

    calculateRemittanceIcon = ->
      switch vm.remittance.status
        when "cancelled" then "icon-cancel"
        when "depositing_disputed", "receiving_disputed" then "icon-lock"
        when "received" then "icon-ok"
        else "icon-hourglass"

    calculateRemittanceIconColorClass = ->
      switch vm.remittance.status
        when "cancelled" then "default"
        when "depositing_disputed", "receiving_disputed" then "danger"
        when "received" then "success"
        else "warning"


    init()
    return
