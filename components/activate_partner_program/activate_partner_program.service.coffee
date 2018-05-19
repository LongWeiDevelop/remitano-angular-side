'use strict'

angular.module 'remitano'
.factory 'PartnerProgram', ($resource) ->
  $resource '/api/v1/partner_program/:action',
    {}
    ,
    activate:
      method: 'POST'
      params:
        action: 'activate'
