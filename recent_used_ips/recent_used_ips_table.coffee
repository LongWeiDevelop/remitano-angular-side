'use strict'

angular.module 'remitano'
.directive "recentUsedIpsTable", (Flash, $translate, dialogs, User) ->
  restrict: "E"
  scope: {}
  templateUrl: "recent_used_ips/recent_used_ips_table.tmpl.html"
  controllerAs: "vm"
  replace: true
  controller: ($scope)->
    vm = @
    return

