'use strict'

angular.module 'remitano'
.directive 'remiWizardStep', ->
  restrict: 'A'
  require: "ngModel"
  scope: false
  link: (scope, element, attrs, ngModel) ->
    focus = -> scope.focusStepElement(element)
    element.bind 'click', focus

    activeValue = parseInt(attrs.active, 10)
    dangerValue = null
    if attrs.danger?
      dangerValue = parseInt(attrs.danger, 10)
    warningValue = parseInt(attrs.warning, 10)

    scope.$watch attrs["ngModel"], (step) ->
      element.removeClass("active")
      element.removeClass("danger")
      element.removeClass("warning")
      if step >= activeValue
        element.addClass("active")
      else if dangerValue? && (step >= dangerValue)
        element.addClass("danger")
      else if step >= warningValue
        element.addClass("warning")
      if step <= activeValue && step >= warningValue
        focus()
