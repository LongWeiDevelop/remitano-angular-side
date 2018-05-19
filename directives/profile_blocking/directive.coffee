#TODO remove this after convert offer details page to React
'use strict'

angular.module 'remitano'
.directive "profileBlocking", ->
  restrict: "E"
  scope:
    username: "="
    isBlocked: "="
  templateUrl: "directives/profile_blocking/tmpl.html"
  replace: true
  bindToController: true
  controllerAs: "vm"
  controller: (dialogs, Profile, $translate) ->
    vm = this
    init = ->
      vm.block = block
      vm.unblock = unblock

    block = ->
      return if vm.isBlocked
      dialog = dialogs.confirm(
        $translate.instant("profile_unblock"),
        $translate.instant("profile_block_explanation")
      )
      dialog.result.then (btn) ->
        updateBlocking(true)

    unblock = ->
      return unless vm.isBlocked
      dialog = dialogs.confirm(
        $translate.instant("profile_unblock"),
        $translate.instant("profile_unblock_explanation")
      )
      dialog.result.then (btn) ->
        updateBlocking(false)

    updateBlocking = (value) ->
      return if vm.updating
      return unless value != vm.isBlocked
      vm.updating = true
      vm.updateError = false

      onUpdateSuccess = (data) ->
        vm.updating = false
        vm.isBlocked = value

      onUpdateError = (err) ->
        vm.updating = false
        vm.updateError = true

      Profile.updateBlock(username: vm.username, is_blocked: value, onUpdateSuccess, onUpdateError)

    init()
    return
