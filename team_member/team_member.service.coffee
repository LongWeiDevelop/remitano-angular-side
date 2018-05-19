'use strict'

angular.module 'remitano'
.factory 'TeamMember', ($resource) ->
  $resource '/api/v1/team_members/:action',
    action: '@action'
  ,
    {}
