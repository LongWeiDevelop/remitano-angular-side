'use strict'

angular.module 'remitano'
.directive 'timePicker', ($timeout) ->
  restrict: 'E'
  replace: true
  require: 'ngModel'
  scope:
    name: "@"
  templateUrl: 'directives/time_picker/tmpl.html'
  controllerAs: 'vm'
  link: (scope, element, attr, ngModelCtrl) ->
    scope.moments = [""]
    hours = for hour in [0..23]
      _.padStart(hour, 2, "0")
    minutes = for m in [0..11]
      _.padStart(m * 5, 2, "0")

    for hour in hours
      for minute in minutes
        scope.moments.push "#{hour}:#{minute}"

    ngModelCtrl.$render = ->
      scope.value = ngModelCtrl.$viewValue || ""
      if scope.value != ""
        scope.value = moment(scope.value).format("HH:mm")
      $timeout -> scope.canSyncNow = true

    scope.$watch "value", (value)->
      return unless scope.canSyncNow
      if value?
        if value == ""
          time = null
        else
          time = moment(value, "HH:mm").toDate()
        ngModelCtrl?.$setViewValue(time)
