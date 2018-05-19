'use strict'

angular.module("remitano").factory "CountryNameTranslate", (COUNTRY_NAMES, $translate) ->
  factory =
    instant: (code) -> COUNTRY_NAMES[$translate.use()][code]

angular.module 'remitano'
.directive 'countryName', ($rootScope, CountryNameTranslate) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    updateTranslation = ->
      element.html CountryNameTranslate.instant(attrs.countryName)
    $rootScope.$on('$translateChangeSuccess', updateTranslation)
    attrs.$observe('countryName', updateTranslation)
    updateTranslation()

.filter 'countryName', (CountryNameTranslate) ->
  (code) ->
    CountryNameTranslate.instant(code)
