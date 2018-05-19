'use strict'

angular.module 'remitano'
.directive 'documentStatusBadge', ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/document_status_badge/tmpl.html'
  scope:
    status: "="
    explanation: "="
  controllerAs: 'vm'
  bindToController: true
  controller: ($scope) ->
    vm = this
    vm.docStatus = vm.status
    vm.docStatusExplanation = vm.explanation
    $scope.$watch "vm.status", ->
      vm.badgeClass = switch vm.status
        when "empty" then ""
        when "pending" then "badge-warning"
        when "rejected" then "badge-danger"
        when "approved" then "badge-success"
    return
