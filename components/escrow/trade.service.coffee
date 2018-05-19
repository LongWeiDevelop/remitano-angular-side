'use strict'

angular.module 'remitano'
.factory 'Trade', ($resource) ->
  $resource '/api/v1/trades/:ref/:action',
    ref: "@ref"
  ,
    query:
      method:'GET'
      isArray: false

    markAsPaid:
      method: "POST"
      params:
        action: "mark_as_paid"

    cancel:
      method: "POST"
      params:
        action: "cancel"

    release:
      method: "POST"
      params:
        action: "release"

    remindTrader:
      method: "POST"
      params:
        action: "remind_trader"

    dispute:
      method: "POST"
      params:
        action: "dispute"

    payViaPoli:
      method: "POST"
      params:
        action: "pay_via_poli"

    reopen:
      method: "POST"
      params:
        action: "reopen"

    fetchFeedback:
      method: "GET"
      params:
        action: "feedback"

    postFeedback:
      method: "POST"
      params:
        action: "feedback"
