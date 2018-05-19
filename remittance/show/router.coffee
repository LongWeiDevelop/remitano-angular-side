'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider
  .state 'root.remittance.show',
    url: '/{ref:R[0-9]{9}}'
    data:
      noSEO: true
      access: AccessLevels.user
    views:
      "":
        templateUrl: 'remittance/show/tmpl.html'
        controllerAs: "vm"
        controller: 'RemittanceShowController'
      "tab-bar":
        template: "<span ng-bind='vm.ref'/>"
        controllerAs: "vm"
        controller: ($stateParams) ->
          @ref = $stateParams.ref
          return
