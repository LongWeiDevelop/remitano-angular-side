'use strict'

angular.module 'remitano'
.directive "policySidebar", () ->
  restrict: "E"
  scope:
    currentPage: "@"
  templateUrl: "policy/sidebar/sidebar.tmpl.html"
  controllerAs: "vm"
  controller: ($scope) ->
    vm = this
    vm.isCollapsed = false
    init = ->
      vm.currentPage = $scope.currentPage
      return

    init()
    return

