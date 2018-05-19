'use strict'
angular.module 'remitano'
  .factory 'alertMissingTranslateValues', ($translate, $state, RAILS_ENV)->
    (translationId, translation, interpolatedTranslation, params, lang) ->
      for match in (translation.match(/\{\{([\w\_]+)\}\}/g) || [])
        key = match[2..-3]
        continue if key == "coin"
        continue if key == "COIN"
        continue if key == "country_name"
        unless params?.hasOwnProperty(key)
          missingRegistry = $.jStorage.get('missingJsTranslations') || {}
          missingRegistry[translationId] = "missing params #{key} for #{translationId} on #{$state.current?.name}"
          $.jStorage.set('missingJsTranslations', missingRegistry)

      interpolatedTranslation
