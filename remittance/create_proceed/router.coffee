'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider
  .state 'root.remittanceCreateProceed',
    url: '/remittances/create_proceed'
    templateUrl: 'remittance/create_proceed/tmpl.html'
    controller: 'RemittanceCreateProceedController as vm'
    data:
      noSEO: true
      access: AccessLevels.user
