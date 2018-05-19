'use strict'

angular.module("remitano").factory "VcbMethodTranslate", ($translate, RAILS_ENV) ->
  factory =
    instant: (method) ->
      switch method
        when "cash_deposit"
          $translate.instant("offer_payment_method_cash_deposit")
        else
          $translate.instant("vcb_#{method}")

angular.module("remitano").directive "vcbMethodTranslate", ($rootScope, VcbMethodTranslate) ->
  restrict: "A"
  link: (scope, element, attrs) ->
    updateTranslation = ->
      element.html VcbMethodTranslate.instant(attrs.vcbMethodTranslate)
    $rootScope.$on('$translateChangeSuccess', updateTranslation)
    attrs.$observe('vcbMethodTranslate', updateTranslation)
    updateTranslation()

angular.module("remitano").filter "vcbMethodTranslate", ($rootScope, VcbMethodTranslate) ->
  (value) -> VcbMethodTranslate.instant(value)
