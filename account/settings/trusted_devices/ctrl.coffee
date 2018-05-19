'use strict'

angular.module 'remitano'
.directive "trustedDevices", (Profile) ->
  restrict: "E"
  templateUrl: "account/settings/trusted_devices/tmpl.html"
  scope: {}
  controllerAs: 'vm'
  controller: (Flash, TrustedDevice) ->
    vm = @
    return
