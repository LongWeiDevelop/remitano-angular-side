'use strict'

angular.module 'remitano'
.factory 'DynamicTitle', ($state, MobileApp, $translate) ->
  set: (title) ->
    @setTranslated($translate.instant(title))

  setTranslated: (translatedTitle) ->
    @data().dynamic_title = translatedTitle
    MobileApp.setTitle(translatedTitle)

  clear: ->
    @data().dynamic_title = null

  data: ->
    $state.$current.data ||= {}
