'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider.state 'root.about',
    url: '/about'
    templateUrl: 'about/about.tmpl.html'
    controller: "AboutController"
    controllerAs: "vm"
    data:
      noFlash: true
      title: 'cano_title_root_about'
