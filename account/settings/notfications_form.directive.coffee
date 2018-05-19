'use strict'

angular.module 'remitano'
.directive "notificationsForm", () ->
  restrict: "E"
  templateUrl: "account/settings/notifications_form.tmpl.html"
  scope: {}
  controllerAs: 'vm'
  controller: ($rootScope, Auth, User, Flash, $translate) ->
    vm = @
    return
