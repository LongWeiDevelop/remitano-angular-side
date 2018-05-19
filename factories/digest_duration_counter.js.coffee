'use strict'

angular.module('remitano').factory "digestDurationCounter", ->
  (scope) ->
    interval = setInterval(interval = ->
      t1 = Date.now()
      scope.$digest()
      scope.digestDuration = (Date.now() - t1)

      # Prevent to log many usely digest duration
      if scope.lastDuration == undefined || Math.abs(scope.digestDuration - scope.lastDuration) > 50
        console.log "Angular Digest Duration Counter: #{scope.digestDuration}ms"
        scope.lastDuration = scope.digestDuration

    , 3000)
    scope.$on "$destroy", ->
      clearInterval interval
      return

