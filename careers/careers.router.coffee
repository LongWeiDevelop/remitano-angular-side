'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider.state 'root.careers',
    url: '/careers'
    templateUrl: 'careers/careers.tmpl.html'
    controller: "CareersController"
    controllerAs: "vm"
    data:
      noFlash: true
      title: 'cano_title_root_careers'
