'use strict'

angular.module 'remitano'
.factory 'Configures', ($resource) ->
  $resource '/api/v1/configures/:action',
    {}
    ,
    setLang:
      method: 'POST'
      params:
        action: 'set_lang'

    setCountry:
      method: 'POST'
      params:
        action: 'set_country'
