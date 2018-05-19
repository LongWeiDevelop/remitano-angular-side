'use strict'

angular.module 'remitano'
.factory 'PhoneNumber', ($resource) ->
  $resource '/api/v1/phone_numbers/:controller',
    {}
    ,
    addPhone:
      method: 'POST'
    requestRemoval:
      method: 'POST'
      params:
        controller: 'request_removal'
    undoRemoval:
      method: 'POST'
      params:
        controller: 'undo_removal'
    processRemoval:
      method: 'POST'
      params:
        controller: 'process_removal'
    verifyPhone:
      method: 'POST'
      params:
        controller: 'verify'
    requestOtpViaPhoneCall:
      method: 'POST'
      params:
        controller: 'request_otp_via_phone_call'
    requestOtpAgain:
      method: 'POST'
      params:
        controller: 'request_otp_again'
