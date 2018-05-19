'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider.state 'root.team',
    url: '/team'
    templateUrl: 'team/team.tmpl.html'
    controller: "TeamController"
    controllerAs: "vm"
    data:
      noFlash: true
      title: 'main_title_team'
