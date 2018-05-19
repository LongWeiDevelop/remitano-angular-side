'use strict'
angular.module 'remitano'
  .factory 'coinAwareInterpolation', ($interpolate, $stateParams, RAILS_ENV) ->
    factory =
      setLocale: ->
      getInterpolationIdentifier: -> 'coinAware'
      interpolate: (string, interpolateParams, context, sanitizeStrategy, translationId) ->
        enhancedInterpolateParams = angular.extend(
          country_name: RAILS_ENV.country_names[$stateParams.country],
          coin: RAILS_ENV.coin_currency_name,
          COIN: RAILS_ENV.coin_currency?.toUpperCase(),
          interpolateParams
        )
        $interpolate(string)(enhancedInterpolateParams, sanitizeStrategy)
