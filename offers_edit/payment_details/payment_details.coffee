'use strict'

angular.module 'remitano'
.directive "offersEditPaymentDetails", () ->
  restrict: "E"
  scope: false
  templateUrl: "offers_edit/payment_details/payment_details.tmpl.html"
  controllerAs: 'payment_subvm'
  controller: ($scope, $stateParams, RAILS_ENV, $translate, PaymentMethodTranslate) ->
    payment_subvm = @
    init = ->
      payment_subvm.availablePaymentTimes = RAILS_ENV.offer_payment_times
      payment_subvm.paymentMethodName = (payment_method) ->
        PaymentMethodTranslate.instant(payment_method)
      payment_subvm.showAdditionalLabel = showAdditionalLabel

      payment_subvm.additionalLabels = {}
      payment_subvm.availablePaymentMethods = []
      payment_subvm.paymentMethodsByName = {}
      for method in RAILS_ENV.offer_payment_methods
        payment_subvm.paymentMethodsByName[method.name] = method
        specific = method.country_codes.length > 0
        continue if specific && !_.includes(method.country_codes, $stateParams.country)
        if method.additional_label
          payment_subvm.additionalLabels[method.name] = method.additional_label
        payment_subvm.availablePaymentMethods.push {value: method.name, name: PaymentMethodTranslate.instant(method.name)}

      $scope.$watch "vm.offer.payment_method", adjustAvailablePaymentTimes
      $scope.$watch "vm.offer.offer_type", adjustAvailablePaymentMethods

    adjustAvailablePaymentMethods = (offer_type) ->
      if $stateParams.country == "au"
        _.remove(payment_subvm.availablePaymentMethods, (ele) ->
          ele.value == "poli_payment"
        )
        if offer_type == "sell"
          payment_subvm.availablePaymentMethods.push {value: "poli_payment", name: PaymentMethodTranslate.instant("poli_payment")}
        else if $scope.vm.offer.payment_method == "poli_payment"
          $scope.vm.offer.payment_method = "local_bank"

    adjustAvailablePaymentTimes = (paymentMethod) ->
      return unless paymentMethod?
      payment_subvm.availablePaymentTimes = switch paymentMethod
        when "local_bank", "alipay", "wechat"
          if $stateParams.country == "in"
            [15, 30, 60, 90, 180]
          else
            [15, 30]
        when "cash_deposit"
          if $stateParams.country == "vn"
            [15, 30]
          else
            [60, 120, 180, 240]
        when "poli_payment" then [15]
        else [15, 30, 60]

      offer = $scope.vm.offer
      if offer? && payment_subvm.availablePaymentTimes.indexOf(offer.payment_time) == -1
        offer.payment_time = payment_subvm.availablePaymentTimes[0]

      $scope.vm.paymentMethod = payment_subvm.paymentMethodsByName[$scope.vm.offer.payment_method]

    showAdditionalLabel = (offer) ->
      excluded_methods = ["local_bank", "cash_deposit", "alipay", "wechat"]
      if payment_subvm.additionalLabels[offer.payment_method] && !_.includes(excluded_methods, offer.payment_method)
        true
      else
        false

    init()
    return
