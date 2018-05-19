'use strict'

angular.module 'remitano'
  .factory 'PhoneVerificator', (Auth, $uibModal) ->
    isVerified: ->
      Auth.currentUser()?.phone_number_status == 'verified'

    request: (onFulfilled, onCancelled = null, message = null) ->
      uibModalInstance = $uibModal.open(
        templateUrl: 'account/phone_verify/phone_verify_form.tmpl.html'
        controller: 'PhoneVerifyFormController as vm'
        size: 'md'
        resolve:
          message: -> message
      )

      uibModalInstance.result.then onFulfilled, onCancelled
