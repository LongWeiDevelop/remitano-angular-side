'use strict'

angular.module 'remitano'
.config ($stateProvider) ->
  $stateProvider
  .state 'root.remittance.new',
    url: '/new'
    templateUrl: 'remittance/new/tmpl.html'
    controller: 'RemittanceNewController as vm'
    data:
      title: 'remittance_header'
