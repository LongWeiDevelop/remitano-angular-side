'use strict'

angular.module 'remitano'
.directive 'remiQr', ->
  restrict: 'E'
  replace: true
  scope:
    text: "@"
  templateUrl: 'directives/remi_qr/tmpl.html'
  controllerAs: 'vm'
  bindToController: true
  controller: ->
    return
