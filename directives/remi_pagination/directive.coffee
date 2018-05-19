'use strict'

angular.module 'remitano'
.directive 'remiPagination', ->
  restrict: 'E'
  scope:
    meta: "="
    onPageChanged: "&"
    maxSize: "@"
  templateUrl: 'directives/remi_pagination/tmpl.html'
  controllerAs: 'vm'
  bindToController: true
  controller: ($scope) ->
    vm = @
    vm.pageChanged = -> vm.onPageChanged($page: vm.currentPage)
    $scope.$watch "vm.meta.per_page", (value) ->
      vm.itemPerPage = value || 10
    vm.currentPage = 1
    vm.maxSize ||= 0
    return
