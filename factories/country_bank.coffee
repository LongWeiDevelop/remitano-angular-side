'use strict'

angular.module 'remitano'
.factory 'CountryBank', ($http, $q, $timeout) ->
  byCountryCode: (countryCode) ->
    factory = this
    $q (resolve, reject) ->
      factory._byCountryCode ||= {}
      if (result = factory._byCountryCode[countryCode])
        return resolve(result)
      $http.get("/api/v1/country_banks", params: { country_code: countryCode }).success (bankNames) =>
        factory._byCountryCode[countryCode] = bankNames
        resolve(bankNames)
