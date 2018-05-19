'use strict'

angular.module 'remitano'
.factory 'ContactMessage', ($resource) ->
  $resource '/api/v1/contact_messages/:id/:controller',
    id: '@id'
