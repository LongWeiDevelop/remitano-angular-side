'use strict'

angular.module('remitano').factory "$exceptionHandler", ($log)->
  (exception, cause) ->
    console.error(exception, cause)
    Rollbar.error(exception, cause: cause) if window.Rollbar
