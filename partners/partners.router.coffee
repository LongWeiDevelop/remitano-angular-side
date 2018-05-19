'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider.state 'root.partners',
    url: '/partners'
    templateUrl: 'partners/partners.tmpl.html'
    controller: "PartnersController"
    controllerAs: "vm"
    data:
      title: 'cano_title_root_partners'
