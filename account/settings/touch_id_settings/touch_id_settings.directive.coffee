'use strict'

angular.module 'remitano'
.directive 'touchIdSettings', () ->
  restrict: 'E'
  templateUrl: 'account/settings/touch_id_settings/touch_id_settings.tmpl.html'
  scope: {}
  controllerAs: 'vm'
  controller: ($state, $scope, MobileApp, Auth, Flash, $translate, $http, $uibModal, dialogs, User, $filter) ->
    vm = @
    init = ->
      vm.twoFactor = {}
      vm.errors = {}
      vm.touchIdAvailable = false
      vm.Auth = Auth
      vm.showEnableTwoFactorForm = showEnableTwoFactorForm
      vm.showDisableTouchIdDialog = showDisableTouchIdDialog
      vm.showEnableTouchIdForm = showEnableTouchIdForm
      vm.submitEnablingTouchId = submitEnablingTouchId
      vm.checkTouchIdAvailability = checkTouchIdAvailability

      vm.assignUser = assignUser
      vm.Util = Util
      vm.assignUser()
      vm.checkTouchIdAvailability()

    $scope.$on('touch_id_availability', (event, value) ->
      vm.touchIdAvailable = value
    )

    $scope.$on('touch_id_confirmed_without_token', (event, value) ->
      vm.touch_id_confirming = false
      vm.touch_id_enabling = value
    )

    $scope.$on('userReloaded', (event, value) ->
      vm.assignUser()
    )

    checkTouchIdAvailability = ->
      MobileApp.checkTouchIdAvailability()

    showEnableTwoFactorForm = ->
      $state.go("root.settings2", { section: "two_factor" })

    showEnableTouchIdForm = ->
      vm.touch_id_confirming = true
      MobileApp.confirmWithTouchIdWithoutToken($translate.instant('settings_enable_touch_id_btn'))

    showDisableTouchIdDialog = ->
      dialog = dialogs.confirm($translate.instant("other_confirmation"),
        "<p>#{$translate.instant("settings_profile_touch_id_removal_confirmation")}</p>
        <small class='hint'>#{$translate.instant("settings_profile_touch_id_removal_confirmation_hint")}</small>"
      )
      dialog.result.then (btn) ->
        Flash.clear()
        Auth.disableTouchId()
        .then ->
          assignUser()
          Flash.add('info', $translate.instant('touch_id_successfully_disabled'))
        .catch (err, data) ->
          Flash.add('danger', err.data.error)

    showEnableTouchIdDialog = ->
      dialog = dialogs.confirm($translate.instant("other_confirmation"),
        "<p>#{$translate.instant("settings_profile_touch_id_removal_confirmation")}</p>
        <small class='hint'>#{$translate.instant("settings_profile_touch_id_removal_confirmation_hint")}</small>"
      )
      dialog.result.then (btn) ->
        Flash.clear()
        Auth.disableTouchId()
        .then ->
          assignUser()
          Flash.add('info', $translate.instant('touch_id_successfully_disabled'))
        .catch (err, data) ->
          Flash.add('danger', err.data.error)

    submitEnablingTouchId = (form) ->
      if form.$valid
        form.submitting = true
        Flash.clear()
        Auth.enableTouchId(vm.twoFactorCode)
        .then ->
          assignUser()
          vm.touch_id_enabling = false
          Flash.add('info', $translate.instant('touch_id_successfully_enabled'))
        .catch (err, data) ->
          Flash.add('danger', err.data.error)
        .finally ->
          form.submitting = false

    assignUser = ->
      vm.user = angular.copy(Auth.currentUser())

    init()
    return
