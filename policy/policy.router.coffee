'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider.state 'root.policy',
    url: '/policy/:page'
    templateUrl: ->
      "policy/policy.html"
    controller: "PolicyController"
    controllerAs: "vm"
    data:
      title: 'footer_legal_policy'

