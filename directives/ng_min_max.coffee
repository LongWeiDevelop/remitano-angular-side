'use strict'

isEmpty = (value) ->
  angular.isUndefined(value) or value == '' or value == null or value != value

isNumber = (n) ->
  !isNaN(parseFloat(n)) and isFinite(n)

angular.module('remitano')
.directive 'ngMin', ->
  restrict: 'A'
  require: 'ngModel'
  link: (scope, elem, attr, ctrl) ->
    scope.$watch attr.ngMin, ->
      ctrl.$setViewValue ctrl.$viewValue
      return

    minValidator = (value) ->
      min = if isNumber(attr.ngMin) then attr.ngMin else (scope.$eval(attr.ngMin) or 0)
      value = parseFloat(value.replace(",", "")) if !isEmpty(value) && typeof(value) == "string"
      if !isEmpty(value) and value < min
        ctrl.$setValidity 'min', false
        undefined
      else
        ctrl.$setValidity 'min', true
        value

    ctrl.$parsers.push minValidator
    ctrl.$formatters.push minValidator
    return

.directive 'ngMax', ->
  restrict: 'A'
  require: 'ngModel'
  link: (scope, elem, attr, ctrl) ->
    scope.$watch attr.ngMax, ->
      ctrl.$setViewValue ctrl.$viewValue
      return

    maxValidator = (value) ->
      max = if isNumber(attr.ngMax) then attr.ngMax else (scope.$eval(attr.ngMax) or Infinity)
      value = parseFloat(value.replace(",", "")) if !isEmpty(value) && typeof(value) == "string"
      if !isEmpty(value) and value > max
        ctrl.$setValidity 'max', false
        undefined
      else
        ctrl.$setValidity 'max', true
        value

    ctrl.$parsers.push maxValidator
    ctrl.$formatters.push maxValidator
    return

