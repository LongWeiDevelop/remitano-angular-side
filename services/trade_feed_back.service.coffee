'use strict'

angular.module 'remitano'
.factory 'TradeFeedBack', ($resource) ->
  $resource '/api/v1/trade_feed_backs/:action',
    action: '@action'
  ,
    featured:
      method:'GET'
      params:
        action: 'featured'
