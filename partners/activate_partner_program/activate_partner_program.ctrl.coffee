'use strict'

angular.module 'remitano'
.controller 'ActivatePartnerProgramController',
($scope, PartnerProgram, Auth, dialogs, $translate) ->

  vm = @

  init = ->
    vm.userVerified = userVerified
    vm.activatable = activatable
    vm.activatePartnerProgram = activatePartnerProgram
    vm.activated = Auth.currentUser()?.referral_program == "twenty_percent_in_one_year"
    return

  activatePartnerProgram = ->
    PartnerProgram.activate({}, activateSuccess, activateError)

  activateError = (data) ->
    dialogs.error($translate.instant("DIALOGS_ERROR"), data.data.error)
    vm.activating = false

  activateSuccess = (data) ->
    Auth.reloadUser().then ->
      vm.activated = true
      vm.activating = false


  activatable = ->
    Auth.currentUser()?.partnerable

  userVerified = ->
    Auth.currentUser()?.doc_status == 'verified'

  init()
  return
