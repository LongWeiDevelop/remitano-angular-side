timerModule = angular.module('timer', []).directive('timer', ($compile) ->
  {
    restrict: 'EA'
    replace: false
    scope:
      interval: '=interval'
      endTimeAttr: '=endTime'
      secondsToDeadline: '=secondsToDeadline'
      finishCallback: '&finishCallback'
    controller: ($scope, $element, $attrs, $timeout, $interpolate) ->
      resetTimeout = ->
        if $scope.timeoutId
          clearTimeout $scope.timeoutId

      calculateTimeUnits = ->
        $scope.seconds = Math.floor($scope.millis / 1000 % 60)
        $scope.minutes = Math.floor($scope.millis / 60000 % 60)
        $scope.hours = Math.floor($scope.millis / 3600000 % 24)
        $scope.days = Math.floor($scope.millis / 3600000 / 24)
        $scope.months = 0
        $scope.years = 0
        $scope.mmillis = $scope.millis % 1000

        if $scope.mmillis < 10
          $scope.mmillis = '00' + $scope.mmillis
        else if $scope.mmillis < 100
          $scope.mmillis = '0' + $scope.mmillis

        #add leading zero if number is smaller than 100
        $scope.sseconds = if $scope.seconds < 10 then '0' + $scope.seconds else $scope.seconds
        $scope.mminutes = if $scope.minutes < 10 then '0' + $scope.minutes else $scope.minutes
        $scope.hhours = if $scope.hours < 10 then '0' + $scope.hours else $scope.hours
        $scope.ddays = if $scope.days < 10 then '0' + $scope.days else $scope.days
        $scope.mmonths = if $scope.months < 10 then '0' + $scope.months else $scope.months
        $scope.yyears = if $scope.years < 10 then '0' + $scope.years else $scope.years

      $element.append $compile($element.contents())($scope)
      $scope.endTime = null
      $scope.timeoutId = null
      $scope.isRunning = false
      $scope.$on 'timer-start', -> $scope.start()
      $scope.$on 'timer-resume', -> $scope.resume()
      $scope.$on 'timer-stop', -> $scope.stop()
      $scope.$on 'timer-clear', -> $scope.clear()
      $scope.$on 'timer-reset', -> $scope.reset()
      $scope.$watch 'endTimeAttr', (newValue, oldValue) ->
        $scope.start()
      $scope.$watch 'secondsToDeadline', (newValue, oldValue) ->
        $scope.start()

      $scope.start = ->
        $scope.startTime = moment()
        if $scope.secondsToDeadline
          $scope.endTime = moment().add($scope.secondsToDeadline, 'seconds')
        else
          $scope.endTime = moment($scope.endTimeAttr)
        resetTimeout()
        tick()
        $scope.isRunning = true

      $scope.resume = ->
        resetTimeout()
        tick()
        $scope.isRunning = true

      $scope.stop = $scope.pause = ->
        timeoutId = $scope.timeoutId
        $scope.clear()
        $scope.$emit 'timer-stopped',
          timeoutId: timeoutId
          millis: $scope.millis
          seconds: $scope.seconds
          minutes: $scope.minutes
          hours: $scope.hours
          days: $scope.days

      $scope.clear = ->
        # same as stop but without the event being triggered
        $scope.stoppedTime = moment()
        resetTimeout()
        $scope.timeoutId = null
        $scope.isRunning = false

      $scope.reset = ->
        if $scope.secondsToDeadline
          $scope.endTime = moment().add($scope.secondsToDeadline, 'seconds')
        else
          $scope.endTime = moment($scope.endTimeAttr)
        resetTimeout()
        tick()
        $scope.isRunning = false
        $scope.clear()

      $element.bind '$destroy', ->
        resetTimeout()
        $scope.isRunning = false

      $scope.millis = 0

      tick = ->
        $scope.millis = moment($scope.endTime).diff(moment())
        if $scope.millis < 0
          $scope.stop()
          $scope.millis = 0
          calculateTimeUnits()
          if $scope.finishCallback
            $scope.$eval $scope.finishCallback
        calculateTimeUnits()
        #We are not using $timeout for a reason. Please read here - https://github.com/siddii/angular-timer/pull/5
        $scope.timeoutId = setTimeout((->
          tick() if $scope.isRunning
          $scope.$digest()
        ), $scope.interval)
        $scope.$emit 'timer-tick',
          timeoutId: $scope.timeoutId
          millis: $scope.millis
          timerElement: $element[0]
      return

  }
)
