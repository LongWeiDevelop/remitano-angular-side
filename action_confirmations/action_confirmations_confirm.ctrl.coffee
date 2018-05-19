'use strict'

angular.module 'remitano'
.controller 'ActionConfirmationConfirmController',
($scope, $state, $stateParams, ActionConfirmation, deviceDetector,
Flash, actionConfirmationRedirector, Auth, MobileApp) ->
  vm = @
  init = ->
    vm.errors = {}
    vm.touchIdFailedCount = 0
    vm.otp = ""
    vm.trustThisDevice = Auth.currentUser().settings?.trust_this_device
    vm.touchIdAvailable = false
    vm.touchIdEnabled = Auth.currentUser().touch_id_enabled
    getAction()

  getAction = ->
    vm.gettingAction = true
    ActionConfirmation.get(id: $stateParams.id).$promise.
      then(getActionSuccess, getActionError).finally ->
        vm.gettingAction = false

  getActionSuccess = (action) ->
    vm.actionConfirmation = action
    vm.submitConfirm = submitConfirm
    vm.confirmWithTouchId = confirmWithTouchId
    vm.checkTouchIdAvailability = checkTouchIdAvailability
    return if checkAlreadyConfirmed()
    vm.checkTouchIdAvailability()

  getActionError = (error) ->
    Flash.displayError(error.data)

  $scope.$on('touch_id_token_received', (event, token) ->
    submitConfirm(token)
  )

  $scope.$on('touch_id_availability', (event, value) ->
    vm.touchIdAvailable = value
  )

  confirmWithTouchId = ->
    MobileApp.confirmWithTouchId(vm.actionConfirmation.message)

  checkTouchIdAvailability = ->
    MobileApp.checkTouchIdAvailability()

  checkAlreadyConfirmed = ->
    if vm.actionConfirmation.status == "confirmed"
      actionConfirmationRedirector.redirect(vm.actionConfirmation)

  submitConfirm = (token)->
    if token
      Flash.clear()
      vm.submitting = true

      submitConfirmSuccess = (actionConfirmation) ->
        vm.actionConfirmation = actionConfirmation
        actionConfirmationRedirector.redirect(vm.actionConfirmation)

      submitConfirmError = (error) ->
        vm.touchIdFailedCount += 1
        Flash.displayError(error.data)

      params =
        id: $stateParams.id
        token: token
        trust_this_device: vm.trustThisDevice

      if vm.trustThisDevice
        params.device =
          os: deviceDetector.os
          browser: deviceDetector.browser
          device: deviceDetector.device
    else
      vm.touchIdFailedCount += 1

    ActionConfirmation.confirm(params, submitConfirmSuccess, submitConfirmError).$promise.finally ->
      vm.submitting = false
  init()
  return
