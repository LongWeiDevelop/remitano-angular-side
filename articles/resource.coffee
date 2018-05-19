'use strict'

angular.module 'remitano'
.factory 'Article', ($resource) ->
  $resource '/api/v1/articles/:id',
    id: '@id'
