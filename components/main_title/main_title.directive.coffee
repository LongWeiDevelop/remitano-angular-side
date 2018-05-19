'use strict'

angular.module 'remitano'
.directive 'mainTitle', () ->
  restrict: 'E'
  templateUrl: 'components/main_title/main_title.tmpl.html'
  scope: { }
  controllerAs: 'vm'
  controller: ($translate, $state) ->
    vm = @
    vm.$state = $state
    return
