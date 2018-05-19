'use strict'

angular.module 'remitano'
.directive 'countryLabel', (RAILS_ENV, CountryNameTranslate) ->
  restrict: 'EA'
  replace: true
  templateUrl: 'directives/country_label/tmpl.html'
  scope:
    country: "@"
    useNativeName: "="
  link: (scope, element, attrs) ->
    attrs.$observe "country", (code) ->
      scope.countryName = if scope.useNativeName
        RAILS_ENV.country_names[code]
      else
        CountryNameTranslate.instant(code)
