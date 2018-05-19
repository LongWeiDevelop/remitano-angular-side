'use strict'

angular.module 'remitano'
.directive 'remiWizard', (bootstrapToolkit) ->
  restrict: 'A'
  scope: true
  link: (scope) ->
    focusElements = []
    maxFocusSize = null

    refocus = ->
      while focusElements.length > maxFocusSize
        element = focusElements.shift()
        element.removeClass("focused")

    scope.focusStepElement = (element) ->
      if (index = focusElements.indexOf(element)) > -1
        focusElements.splice(index, 1)
      focusElements.push(element)
      refocus()
      element.addClass("focused")


    bootstrapResize = ->
      maxFocusSize = switch bootstrapToolkit.currentBreakpoint
        when "xs", "sm" then 1
        when "md" then 2
        when "lg" then 3

      refocus()

    scope.$on "bootstrap-resize", bootstrapResize
    bootstrapResize()
