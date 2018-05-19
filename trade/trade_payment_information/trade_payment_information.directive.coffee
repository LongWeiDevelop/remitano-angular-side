'use strict'

angular.module 'remitano'
.directive "tradePaymentInformation", ->
  restrict: "E"
  templateUrl: "trade/trade_payment_information/trade_payment_information.tmpl.html"
  scope:
    tradeWithRole: "="
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, RAILS_ENV) ->
    vm = @
    init = ->
      vm.role = vm.tradeWithRole.role
      vm.additionalBankFields = additionalBankFields
      vm.hasAppendix = hasAppendix
      vm.showDelayMessage = showDelayMessage
      $scope.$watch "vm.tradeWithRole.trade", (trade) ->
        vm.trade = trade
        vm.payment_details = vm.tradeWithRole.payment_details
        vm.bank_corp = vm.tradeWithRole.bank_corp
        vm.payment_method = vm.tradeWithRole.payment_method
        vm.banking_memo = vm.tradeWithRole.banking_memo
        return unless vm.trade?
        return(vm.visible = false) if trade.is_seller_banned
        visibleStatus = ['unpaid', 'paid', 'disputed']
        if vm.role == "seller"
          visibleStatus.push 'awaiting'

        if _.includes(visibleStatus, vm.trade.status)
          vm.visible = true
        else if vm.tradeWithRole.fiat_deposit?.status == "ready"
          vm.visible = true
          vm.tradeCancelled = _.includes(["cancelled", "cancelled_automatically"], vm.trade.status)
        else
          vm.visible = false

    hasAppendix = ->
      if vm.tradeWithRole?.fiat_deposit?.required_appendix_fields && vm.tradeWithRole?.fiat_deposit?.required_appendix_fields?.length > 0
        return true
      else
        return false

    showDelayMessage = ->
      return false unless vm.bank_corp
      d = new Date()
      n = d.getHours()
      (n >= 22 || d < new Date().setHours(23, 59, 59, 999)) && vm.country_code == 'vn'

    additionalBankFields = ->
      return [] unless vm.trade?.offer_data?
      country_code = vm.trade.offer_data.country_code
      RAILS_ENV.additional_bank_fields[country_code] || []

    init()
    return
