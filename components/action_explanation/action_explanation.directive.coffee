'use strict'

angular.module 'remitano'
.directive 'actionExplanation', () ->
  restrict: 'E'
  replace: true
  templateUrl: 'components/action_explanation/action_explanation.tmpl.html'
  scope: { actionConfirmation: "=" }
