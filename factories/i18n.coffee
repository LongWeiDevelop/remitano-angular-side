angular.module("remitano").factory "i18n", (RAILS_ENV) ->
  factory =
    country: ->
      RAILS_ENV.country
    nativeLocale: ->
      RAILS_ENV.country_locale[RAILS_ENV.country]
    locale: ->
      RAILS_ENV.locale
