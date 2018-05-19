'use strict'

angular.module('remitano')
.directive 'cmdEnterSubmit', ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    elem.bind 'keydown', (event) ->
      code = event.keyCode or event.which
      if code == 13
        if event.metaKey
          event.preventDefault()
          scope.$apply attrs.cmdEnterSubmit

