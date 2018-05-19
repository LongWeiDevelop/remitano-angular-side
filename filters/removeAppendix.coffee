'use strict'

angular.module 'remitano'
.filter "removeAppendix", ->
  (paymentDetails) ->
    result = {}
    for key, value of paymentDetails
      unless /^appendix_/.test(key)
        result[key] = value
    result
