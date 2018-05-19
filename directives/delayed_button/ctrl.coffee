'use strict'

angular.module 'remitano'
.directive 'delayedButton', ->
  restrict: "E"
  replace: true
  templateUrl: "directives/delayed_button/tmpl.html"
  scope:
    processing: "="
    enabledAt: "="
    onClick: "&"
    caption: "@"
  controllerAs: "vm"
  bindToController: true
  controller:  ($scope) ->
    vm = this
    init = ->
      vm.enabled = false
      vm.enable = enable
      vm.internalClick = ($event) ->
        vm.onClick('$event': $event)
      $scope.$watch "vm.enabledAt", (value) ->
        if value?
          vm.enabledAtMs = value * 1000
          vm.enabled = moment(vm.enabledAtMs).diff(moment()) < 0
        else
          vm.enabledAtMs = null
          vm.enabled = false

    enable = ->
      vm.enabled = true
      $scope.$applyAsync()

    init()
    return
