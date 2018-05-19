'use strict'

angular.module 'remitano'
.directive 'twoFactorAuthForm', () ->
  restrict: 'E'
  templateUrl: 'account/settings/two_factor_auth/two_factor_auth_form.tmpl.html'
  scope: {}
  controllerAs: 'vm'
  controller: ($scope, $rootScope, MobileApp, Auth, Flash, $translate, $http, $uibModal, dialogs, User, $filter) ->
    vm = @
    init = ->
      vm.twoFactor = {}
      vm.errors = {}
      vm.Auth = Auth
      vm.showEnableTwoFactorForm = showEnableTwoFactorForm
      vm.submitEnablingTwoFactor = submitEnablingTwoFactor
      vm.showDisableTwoFactorForm = showDisableTwoFactorForm
      vm.submitDisablingTwoFactor = submitDisablingTwoFactor
      vm.lostAuthy = lostAuthy
      vm.disableAuthyAfterTime = disableAuthyAfterTime

      vm.assignUser = assignUser
      vm.openAuthyUsageHelp = openAuthyUsageHelp
      vm.Util = Util
      vm.assignUser()
      vm.lostingAuthy = false
      $rootScope.$on "userReloaded", ->
        reloadDisableTwoFactorRequest()

    reloadDisableTwoFactorRequest = ->
      return unless Auth.isLoggedIn()
      vm.assignUser()

    showEnableTwoFactorForm = ->
      Flash.clear()
      success = (data, status, headers, config) ->
        vm.twoFactorCode = ''
        vm.twoFactor = data
        vm.enabling = true

      error = (data, status, headers, config) ->
        Flash.add('danger', data.error)

      $http.get('/api/v1/two_factor_auth/new_key').success(success).error(error)

    showDisableTwoFactorForm = ->
      vm.twoFactorCode = ''
      vm.disabling = true

    submitEnablingTwoFactor = (form) ->
      vm.submitted = true

      if form.$valid
        Flash.clear()
        form.submitting = true
        Auth.enableTwoFactor(vm.twoFactorCode)
        .then ->
          assignUser()
          Flash.add('info', $translate.instant('two_factor_successfully_enabled'))
          vm.enabling = false
          vm.disabling = false
        .catch (err, data) ->
          Flash.add('danger', err.data.error)
        .finally ->
          form.submitting = true

    submitDisablingTwoFactor = (form) ->
      vm.submitted = true

      if form.$valid
        Flash.clear()
        Auth.disableTwoFactor(vm.twoFactorCode)
        .then ->
          assignUser()
          Flash.add('info', $translate.instant('two_factor_successfully_disabled'))
        .catch (err, data) ->
          Flash.add('danger', err.data.error)

    lostAuthy = ->
      vm.lostingAuthy = true

    disableAuthyAfterTime = ->
      vm.lostingAuthy = false
      dialog = dialogs.confirm($translate.instant("other_confirmation"),
        "<p>#{$translate.instant("settings_profile_two_factor_removal_confirmation")}</p>
        <small class='hint'>#{$translate.instant("settings_profile_two_factor_removal_confirmation_hint", removal_time: $filter("amCalendar")(vm.user.two_factor_removal_delay))}</small>"
      )
      dialog.result.then (btn) ->
        vm.submitted = true
        Flash.clear()
        onSuccess = (res) ->
          if res.success
            Auth.reloadUser().then ->
              assignUser()

        onError = (res) ->
          Flash.displayError(res.data)

        User.twoFactorRequestRemoval().$promise.then(onSuccess, onError)

    assignUser = ->
      vm.user = angular.copy(Auth.currentUser())
      vm.actionVerificationDisableTwoFactor =
        (vm.user.action_verifications || []).find ((av) -> av.action == "disable_two_factor!")

    openAuthyUsageHelp = ->
      uibModalInstance = $uibModal.open(
        templateUrl: 'account/settings/two_factor_auth/two_factor_authy_tutorial.tmpl.html'
        controller: 'TwoFactorAuthyTutorialController as vm'
        size: 'lg'
      )

    init()
    return
