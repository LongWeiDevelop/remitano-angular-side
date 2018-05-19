'use strict'

angular.module 'remitano'
.factory 'Blocking', ($resource) ->
  $resource '/api/v1/blockings',
    {}
  ,
    query:
      method:'GET'
