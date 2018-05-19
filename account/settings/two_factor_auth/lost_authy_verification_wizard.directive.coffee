'use strict'

angular.module 'remitano'
.directive 'lostAuthyVerificationWizard', () ->
  restrict: 'E'
  templateUrl: 'account/settings/two_factor_auth/lost_authy_verification_wizard.tmpl.html'
  scope:
    actionVerification: "="
    lostingAuthy: "="
  controllerAs: 'vm'
  bindToController: true
  controller: ($scope, Auth) ->
    vm = @
    init = ->
      vm.docType = "confirmation_image"
      vm.mediaType = "image"
      vm.uploadPath = "/api/v1/users/request_disable_two_factor"

      vm.step = 0
      vm.step = 1 if Auth.currentUser().doc_status == "verified"
      vm.documentUploaded = documentUploaded
      vm.documentStatus = vm.actionVerification?.status || "empty"
      return

    documentUploaded = (response) ->
      vm.actionVerification = response
      vm.documentStatus = vm.actionVerification.status
      Auth.reloadUser()
      vm.lostingAuthy = false

    init()
    return
