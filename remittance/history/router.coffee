'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider
  .state 'root.remittance.history',
    url: '/history'
    templateUrl: 'remittance/history/tmpl.html'
    controller: 'RemittanceHistoryController'
    controllerAs: "vm"
    data:
      noSEO: true
      title: 'history'
      access: AccessLevels.user
