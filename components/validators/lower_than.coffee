'use strict'

angular.module 'remitano'
.directive "lowerThan", [->
  link = ($scope, $element, $attrs, ctrl) ->
    validate = (viewValue) ->
      comparisonModel = $attrs.lowerThan
      # It's valid because we have nothing to compare against
      ctrl.$setValidity "lowerThan", true  if not viewValue or not comparisonModel
      # It's valid if model is lower than the model we're comparing against
      ctrl.$setValidity "lowerThan", parseFloat(viewValue, 10) < parseFloat(comparisonModel, 10)
      viewValue
    ctrl.$parsers.unshift validate
    ctrl.$formatters.push validate
    $attrs.$observe "lowerThan", (comparisonModel) ->
      validate ctrl.$viewValue
  require: "ngModel"
  link: link
]
.directive "lowerOrEqualTo", [->
  link = ($scope, $element, $attrs, ctrl) ->
    validate = (viewValue) ->
      comparisonModel = $attrs.lowerOrEqualTo
      ctrl.$setValidity "lowerOrEqualTo", true if not viewValue or not comparisonModel
      ctrl.$setValidity "lowerOrEqualTo", parseFloat(viewValue, 10) <= parseFloat(comparisonModel, 10)
      viewValue
    ctrl.$parsers.unshift validate
    ctrl.$formatters.push validate
    $attrs.$observe "lowerOrEqualTo", (comparisonModel) ->
      validate ctrl.$viewValue
  require: "ngModel"
  link: link
]
