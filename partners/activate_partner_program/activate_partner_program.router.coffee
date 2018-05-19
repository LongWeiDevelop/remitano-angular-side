'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider.state 'root.activate_partner_program',
    url: '/activate_partner_program'
    templateUrl: 'partners/activate_partner_program/activate_partner_program.tmpl.html'
    controller: "ActivatePartnerProgramController"
    controllerAs: "vm"
    data:
      title: 'cano_title_root_activate_partner_program'
      access: AccessLevels.user
