'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider
  .state 'root.dashboard',
    abstract: true
    templateUrl: 'dashboard/dashboard.tmpl.html'
    data:
      access: AccessLevels.user
      title: 'dashboard_dashboard'
