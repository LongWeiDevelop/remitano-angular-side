'use strict'

angular.module 'remitano'
.config ($stateProvider, $urlRouterProvider) ->
  $stateProvider
  .state 'root.fees',
    url: '/fees'
    templateUrl: 'fees/fees.tmpl.html'
    data:
      title: 'fees_title'
