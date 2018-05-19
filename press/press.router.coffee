'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider.state 'root.press',
    url: '/press'
    templateUrl: 'press/press.tmpl.html'
    controller: "PressController"
    controllerAs: "vm"
    data:
      noFlash: true
      title: 'cano_title_root_press'
