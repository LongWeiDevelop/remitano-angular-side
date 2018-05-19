'use strict'

angular.module 'remitano'
.controller 'ChatRequestDialogController', ($uibModalInstance, ChatRequest, Auth, Flash, $translate) ->
  vm = this
  email = Auth.currentUser()?.email
  email ||= $.jStorage.get("chatRequestEmail")
  vm.chatRequest = { from: email }
  vm.signedIn = Auth.currentUser()?

  vm.submitRequest = (status) ->
    return if vm.submitting
    $.jStorage.set("chatRequestEmail", vm.chatRequest.from)
    vm.submitting = true
    vm.message = null
    ChatRequest.save(vm.chatRequest).$promise.
      then(submitRequestSuccess, submitRequestError).
      finally -> vm.submitting = false

  submitRequestSuccess = ->
    vm.message =
      content: $translate.instant("customer_support_request_submitted")
      type: 'alert-success'

    vm.submitted = true

  submitRequestError = (response) ->
    vm.message =
      content: Flash.getMessage(response.data)
      type: 'alert-danger'

  vm.close = ->
    $uibModalInstance.dismiss('close')
  return


