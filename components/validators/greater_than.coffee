'use strict'

angular.module 'remitano'
.directive "greaterThan", [->
  link = ($scope, $element, $attrs, ctrl) ->
    validate = (viewValue) ->
      comparisonModel = $attrs.greaterThan

      # It's valid because we have nothing to compare against
      ctrl.$setValidity "greaterThan", true  if not viewValue or not comparisonModel

      # It's valid if model is lower than the model we're comparing against
      ctrl.$setValidity "greaterThan", parseFloat(viewValue, 10) > parseFloat(comparisonModel, 10)
      viewValue

    ctrl.$parsers.unshift validate
    ctrl.$formatters.push validate
    $attrs.$observe "greaterThan", (comparisonModel) ->
      validate ctrl.$viewValue
  require: "ngModel"
  link: link
]
.directive "greaterOrEqualTo", [->
  link = ($scope, $element, $attrs, ctrl) ->
    validate = (viewValue) ->
      comparisonModel = $attrs.greaterOrEqualTo
      ctrl.$setValidity "greaterOrEqualTo", true if not viewValue or not comparisonModel
      ctrl.$setValidity "greaterOrEqualTo", parseFloat(viewValue, 10) >= parseFloat(comparisonModel, 10)
      viewValue
    ctrl.$parsers.unshift validate
    ctrl.$formatters.push validate
    $attrs.$observe "greaterOrEqualTo", (comparisonModel) ->
      validate ctrl.$viewValue
  require: "ngModel"
  link: link
]
