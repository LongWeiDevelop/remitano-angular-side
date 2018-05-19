"use strict"

angular.module "remitano"
.config (AccessLevels, $stateProvider) ->
  $stateProvider
  .state "root.actionVerificationCancel",
    url: "/action_verifications/:id/cancel"
    template: "<div/>"
    controller: (ActionVerification, Flash, $stateParams, $state, $translate) ->
      successCallback = (action) ->
        Flash.addCache 'success', $translate.instant("action_verification_cancelled_successfully")
        $state.go("root.settings2", { section: "two_factor" })

      errorCallback = ->
        Flash.addCache 'danger', $translate.instant("action_verification_not_found_or_expired")
        $state.go("root.landing")

      ActionVerification.cancel(id: $stateParams.id).$promise.then(successCallback, errorCallback)
    data:
      access: AccessLevels.user
