'use strict'

angular.module("remitano").directive "showErrorFor", ($rootScope, PaymentMethodTranslate) ->
  require: "^form"
  restrict: "A"
  link: (scope, element, attrs, ngFormCtrl) ->
    always = attrs.always
    submitted = false
    error = false

    setClass = ->
      if (submitted || always) && error
        element.removeClass("ng-hide")
      else
        element.addClass("ng-hide")

    scope.$watch (-> ngFormCtrl[attrs.showErrorFor]?.$error?[attrs.error]), (bool) ->
      error = bool
      setClass()

    scope.$watch (-> ngFormCtrl.$submitted), (bool) ->
      submitted = bool
      setClass()
