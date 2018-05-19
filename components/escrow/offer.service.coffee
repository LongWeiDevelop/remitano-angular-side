'use strict'

angular.module 'remitano'
.factory 'Offer', ($resource) ->
  $resource '/api/v1/offers/:id/:action',
    id: "@id"
  ,
    enable:
      method: "PUT"
      params:
        action: "enable"
    disable:
      method: "PUT"
      params:
        action: "disable"
    update:
      method: "PUT"
    getEdit:
      method: "GET"
      params:
        action: "edit"
    my_offers:
      method: "GET"
      params:
        id: "my_offers"
      isArray: false
    query:
      method:'GET'
      isArray: false
    remove:
      method: "PUT"
      params:
        action: "remove"
    best:
      method: "POST"
      isArray: true
      params:
        action: "best"
