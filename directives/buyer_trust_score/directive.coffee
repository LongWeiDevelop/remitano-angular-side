'use strict'

angular.module 'remitano'
.directive 'buyerTrustScore', ->
  restrict: 'E'
  templateUrl: 'directives/buyer_trust_score/tmpl.html'
  scope:
    trustScore: "="
  controllerAs: 'vm'
  bindToController: true
  controller: ($scope) ->
    vm = this
    $scope.$watch "vm.trustScore", ->
      vm.trustClass = if vm.trustScore > 0.9
        "safe"
      else if vm.trustScore > 0.6
        "warning"
      else
        "danger"

    return
