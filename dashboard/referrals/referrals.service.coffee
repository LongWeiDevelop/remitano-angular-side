'use strict'

angular.module 'remitano'
.factory 'Referrals', ($resource) ->
  $resource '/api/v1/referrals/',
    {}
  ,
    query:
      method: 'GET'
