'use strict'

angular.module 'remitano'
.directive 'phoneRemovalWarning', () ->
  restrict: 'E'
  templateUrl: 'directives/phone_removal_warning/tmpl.html'
  scope:
    fullDetails: "="
  controllerAs: 'vm'
  bindToController: true
  controller: (Auth, $rootScope, $filter, PhoneNumber,
  dialogs, Flash, $translate, prompt ) ->
    vm = @
    return
