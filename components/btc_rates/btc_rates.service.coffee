'use strict'

angular.module 'remitano'
.factory 'BtcRates', ($resource) ->
  $resource '/api/v1/btc_rates/:action',
    {}
    ,
    fetch:
      method: 'GET'
      params:
        action: 'fetch'
    fetchExchange:
      method: 'GET'
      params:
        action: 'fetch_exchange'
