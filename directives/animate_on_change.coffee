'use strict'

angular.module('remitano')
.directive "animateOnChange", ($animate, $timeout) ->
  (scope, elem, attr) ->
    scope.$watch attr.animateOnChange, (nv, ov) ->
      unless nv is ov
        klass = if nv != ov then "change" else ""
        $animate.addClass elem, klass
        $timeout (-> elem.removeClass(klass)), 1000

