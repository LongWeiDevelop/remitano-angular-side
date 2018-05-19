'use strict'

angular.module 'remitano'
.directive 'twoFactorRemovalWarning', () ->
  restrict: 'E'
  templateUrl: 'directives/two_factor_removal_warning/tmpl.html'
  scope:
    fullDetails: "="
  controllerAs: 'vm'
  bindToController: true
  controller: (Auth, $rootScope, User,
  dialogs, Flash, $translate, prompt ) ->
    vm = @
    init = ->
      reloadDisableTwoFactorRequest()
      vm.undoTwoFactorRemoval = undoTwoFactorRemoval

    $rootScope.$on "userReloaded", ->
      reloadDisableTwoFactorRequest()

    reloadDisableTwoFactorRequest = ->
      return unless Auth.isLoggedIn()
      vm.two_factor_removal_time = Auth.currentUser().two_factor_removal_time
      vm.actionVerificationDisableTwoFactor =
        (Auth.currentUser().action_verifications || []).find ((av) -> av.action == "disable_two_factor!")

    undoTwoFactorRemoval = () ->
      Flash.clear()
      onSuccess = (res) ->
        Auth.reloadUser() if res.success

      onError = (res) ->
        Flash.displayError(res.data)

      User.twoFactorUndoRemoval().$promise.then(onSuccess, onError)
      return

    init()
    return
