'use strict'

angular.module 'remitano'
.factory 'Profile', ($resource) ->
  $resource '/api/v1/profile/:username/:action',
    username: '@username'
  ,
    getFeedbacks:
      method: "GET"
      params:
        action: "feedbacks"
    updateBlock:
      method: "POST"
      params:
        action: "update_block"
