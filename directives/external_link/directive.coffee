'use strict'

angular.module 'remitano'
.directive 'externalLink', ->
  restrict: 'E'
  scope: {
    'href': "@"
  }
  templateUrl: 'directives/external_link/tmpl.html'
  controllerAs: 'vm'
  bindToController: true
  transclude: true
  controller: (Auth, MobileApp, $scope) ->
    vm = this
    init = ->
      vm.openExternalLink = openExternalLink
      return

    openExternalLink = () ->
      MobileApp.openExternalLink(vm.href)

    init()
    return
