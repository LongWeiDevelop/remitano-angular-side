'use strict'

angular.module("remitano").factory "PaymentMethodTranslate", ($translate, RAILS_ENV) ->
  factory =
    instant: (method) ->
      switch method
        when "local_bank", "cash_deposit", "sepa_bank", "alipay", "wechat", "poli_payment"
          $translate.instant("offer_payment_method_#{method}")
        when "fiat_deposit"
          if RAILS_ENV.current_country == "in"
            $translate.instant("offer_payment_method_imps_payments")
          else
            $translate.instant("offer_payment_method_local_bank")
        when "fiat_wallet"
          $translate.instant("offer_payment_method_fiat_wallet")
        else
          method

angular.module("remitano").directive "pmTranslate", ($rootScope, PaymentMethodTranslate) ->
  restrict: "A"
  link: (scope, element, attrs) ->
    updateTranslation = ->
      element.html PaymentMethodTranslate.instant(attrs.pmTranslate)
    $rootScope.$on('$translateChangeSuccess', updateTranslation)
    attrs.$observe('pmTranslate', updateTranslation)
    updateTranslation()
