'use strict'

angular.module("remitano").directive "hasErrorFor", ($rootScope, PaymentMethodTranslate) ->
  require: "^form"
  restrict: "A"
  controllerAs: 'hef'
  link: (scope, element, attrs, ngFormCtrl) ->
    submitted = false
    invalid = false

    setClass = ->
      if submitted && invalid
        element.addClass("has-error")
      else
        element.removeClass("has-error")

      if scope.hef.warning
        element.addClass("has-warning")
      else
        element.removeClass("has-warning")

      if scope.hef.success
        element.addClass("has-success")
      else
        element.removeClass("has-success")

    scope.$watch (-> ngFormCtrl[attrs.hasErrorFor]?.$invalid), (bool) ->
      invalid = bool
      setClass()

    scope.$watch (-> ngFormCtrl.$submitted), (bool) ->
      submitted = bool
      setClass()

    scope.$watch "hef.warning", setClass
    scope.$watch "hef.success", setClass

  controller: ->
