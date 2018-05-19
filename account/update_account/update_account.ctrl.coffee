'use strict'

angular.module('remitano')
.controller 'UpdateAccountController', ($scope, Auth, Flash, $state, $translate) ->
  vm = @

  init = ->
    unless Auth.isTemporary()
      $state.go('root.home')
    vm.update_account = update_account
    vm.errors = {}
    vm.user = {}
    vm.resetValidity = resetValidity

  update_account = (form) ->
    vm.errors = {}
    resetValidity(form)

    if form.$valid
      form.submitting = true
      Auth.updateNewAccount(angular.copy(vm.user))
      .then (data) ->
        Auth.setAfterLoginState(data.state?.name, data.state?.params)
        Auth.reloadUser()
        .then ->
          Flash.addCache('info', $translate.instant("account_update_success"))
          Auth.goToAfterLoginState()
      .catch (err) ->
        vm.errors = {}

        angular.forEach err.data.errors, (fieldErrors, field) ->
          vm.errors[field] = fieldErrors.join(', ')
          return unless form[field]
          form[field].$setValidity 'rails', false
          form[field].$dirty = true
      .finally ->
        form.submitting = false

  resetValidity = (form) ->
    angular.forEach ['username'], (field) ->
      form[field].$setValidity 'rails', true

  init()
  return
