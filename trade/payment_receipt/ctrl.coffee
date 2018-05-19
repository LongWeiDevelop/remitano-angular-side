'use strict'

angular.module 'remitano'
.directive "paymentReceipt", ->
  restrict: "E"
  templateUrl: "trade/payment_receipt/tmpl.html"
  scope:
    tradeWithRole: "="
  controllerAs: "vm"
  bindToController: true
  controller: ($scope) ->
    vm = @
    init = ->
      $scope.$watch "vm.tradeWithRole.trade", (trade) ->
        vm.trade = trade
        return unless vm.trade?
        return(vm.visible = false) unless trade.offer_data.payment_method == "cash_deposit"
        visibleStatus = ['paid', 'disputed']
        vm.visible = _.includes(visibleStatus, vm.trade.status)

    init()
    return
