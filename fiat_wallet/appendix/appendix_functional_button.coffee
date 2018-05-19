'use strict'

angular.module 'remitano'
.directive "appendixFunctionalButton", (FiatDeposit, $uibModal, Auth, SocketWrapper) ->
  restrict: "E"
  templateUrl: "fiat_wallet/appendix/appendix_functional_button.tmpl.html"
  controllerAs: "vm"
  scope:
    fiatDeposit: "="
  bindToController: true
  controller: ($scope) ->
    vm = this

    init = ->
      vm.openAppendixForm = openAppendixForm
      vm.isAppendixSubmitted = isAppendixSubmitted
      vm.hasAppendixFeedback = hasAppendixFeedback
      subscribeDepositChanged()

    subscribeDepositChanged = ->
      user_id = Auth.currentUser().id
      SocketWrapper.subscribe $scope, "private-user_#{user_id}@fiat_deposit_channel_#{vm.fiatDeposit.id}", "updated", handleFiatDepositUpdated

    handleFiatDepositUpdated = (event, data) -> angular.extend(vm.fiatDeposit, data)

    hasAppendixFeedback = ->
      return false unless vm.fiatDeposit.appendix_feedback
      return false if vm.fiatDeposit.appendix_feedback.status == 'appendix_empty'
      true

    isAppendixSubmitted = ->
      for field in vm.fiatDeposit.required_appendix_fields
        value = vm.fiatDeposit.appendix[field]
        return true if value?.length > 0
      false

    openAppendixForm = ->
      uibModalInstance = $uibModal.open(
        templateUrl: "fiat_wallet/appendix/fiat_deposit_appendix_dialog.tmpl.html"
        controller: "fiatDepositAppendixDialogCtrl as vm"
        size: "md"
        backdrop: 'static'
        keyboard: false
        resolve:
          fiatDeposit: -> vm.fiatDeposit
          appendix: -> vm.fiatDeposit.appendix
          requiredAppendixFields: -> vm.fiatDeposit.required_appendix_fields
      )

      onSubmitSuccess = (data) ->
        vm.fiatDeposit = data

      uibModalInstance.result.then onSubmitSuccess


    init()
    return
