'use strict'
angular.module 'remitano'
  .factory 'alertMissingTranslationHandler', ($state, $translate)->
    (translationId) ->
      return if $translate.use() != "en"
      console.error "MissingJsTranslationError #{translationId}"
      err = new Error()
      console.error err.stack
      missingRegistry = $.jStorage.get('missingJsTranslations') || {}
      missingRegistry[translationId] = $state.current?.name
      $.jStorage.set('missingJsTranslations', missingRegistry)
