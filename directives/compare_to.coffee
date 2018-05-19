'use strict'

angular.module('remitano')
.directive "compareTo", ->
  require: "ngModel"
  scope:
    otherModelValue: "=compareTo"
  link: (scope, element, attributes, ngModel) ->
    ngModel.$validators.compareTo = (modelValue) ->
      return modelValue == scope.otherModelValue

    scope.$watch "otherModelValue", ->
      ngModel.$validate()
