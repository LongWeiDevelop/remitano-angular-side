'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider.state 'root.escrowService',
    url: '/escrow_service'
    templateUrl: 'escrow_service/escrow_service.tmpl.html'
    controller: "EscrowServiceController"
    controllerAs: "vm"
    data:
      noFlash: true
      title: 'main_title_escrowService'
