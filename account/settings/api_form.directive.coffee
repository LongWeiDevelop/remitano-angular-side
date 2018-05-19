'use strict'

angular.module 'remitano'
.directive "apiForm", () ->
  restrict: "E"
  templateUrl: "account/settings/api_form.tmpl.html"
  scope: {}
  controllerAs: 'vm'
  controller: (Auth, Flash, $translate) ->
    vm = @
    init = ->
      vm.user = angular.copy(ctrl.Auth.currentUser())
      vm.errors = {}
      vm.Auth = Auth

      vm.generateApi = generateApi

    generateApi = (form) ->
      vm.submitted = true

      if confirm($translate.instant("are_you_sure"))
        form.submitting = true
        Flash.clear()
        Auth.generateApi()
        .then (result) ->
          vm.user = result
          Flash.add('info', $translate.instant("settings_generate_api_success"), true)
        .catch (err) ->
          Flash.displayError(err.data)
        .finally ->
          form.submitting = false
    init()
    return
