"use strict"

angular.module "remitano"
.config (AccessLevels, $stateProvider) ->
  $stateProvider
  .state "root.actionConfirmationConfirm",
    url: "/action/{id:[0-9]+}/confirm?token"
    templateUrl: "action_confirmations/confirm.tmpl.html"
    controller: "ActionConfirmationConfirmController"
    controllerAs: "vm"
    data:
      access: AccessLevels.user
  .state "root.actionConfirmationRedirect",
    url: "/action/{id:[0-9]+}/redirect"
    template: "<div/>"
    controller: (ActionConfirmation, Flash, actionConfirmationRedirector, $stateParams, $state, $translate) ->
      getActionConfirmationSuccess = (action) ->
          actionConfirmationRedirector.redirect(action)

      getActionConfirmationError = ->
        Flash.addCache 'danger', $translate.instant("action_confirmation_not_found")
        $state.go("root.landing")

      ActionConfirmation.get(id: $stateParams.id).$promise.then(getActionConfirmationSuccess, getActionConfirmationError)
    data:
      access: AccessLevels.user
