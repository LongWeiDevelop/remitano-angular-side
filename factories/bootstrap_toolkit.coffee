'use strict'

angular.module 'remitano'
.factory "bootstrapToolkit", ($window, $rootScope) ->
  factory =
    calculateBreakpoint: ->
      windowWidth = window.innerWidth
      if windowWidth < 768
        'xs'
      else if windowWidth < 992
        'sm'
      else if windowWidth < 1200
        'md'
      else
        'lg'

  factory.currentBreakpoint = factory.calculateBreakpoint()

  windowResized = ->
    newBreakpoint = factory.calculateBreakpoint()
    if newBreakpoint != factory.currentBreakpoint
      factory.currentBreakpoint = newBreakpoint
      $rootScope.$broadcast("bootstrap-resize")

  angular.element($window).on 'resize', windowResized

  factory
