'use strict'

angular.module('remitano')
.factory 'Flash', ($rootScope, RAILS_ENV, $translate, $ngRedux) ->
  Flash =
    messages: []
    clear: ->
      @messages = []
      $ngRedux.dispatch
        type: 'remitano/Shared/FlashMessages/CLEAR_FLASH_MESSAGES'
    add: (type, text, autoVanish, unique) ->
      return if unique && @messages.some ((message)-> message.text == text)
      messageId = (new Date()).getTime()
      @clear()
      @messages.push
        message_id: messageId
        type: type
        text: text
      if autoVanish
        vanish = =>
          @delete(messageId)
          $rootScope.$evalAsync()
        setTimeout vanish, if RAILS_ENV.env == "test" then 7000 else 3000
    delete: (messageId) ->
      message = @messages.find (message) -> message.message_id == messageId
      return unless message
      @messages.remove (message) -> message.message_id == messageId
    addCache: (type, text, unique) ->
      cachedMessages = $.jStorage.get('flash.messages') || []
      return if unique && cachedMessages.some ((message)-> message.text == text)
      cachedMessages.push
        type: type
        text: text
      $.jStorage.set('flash.messages', cachedMessages)
    popCache: ->
      cachedMessages = $.jStorage.get('flash.messages') || []
      $.jStorage.set('flash.messages', [])
      angular.forEach cachedMessages, (message) ->
        Flash.add(message.type, message.text)

    getMessage: (errData) ->
      errData?.error || $translate.instant("other_internal_server_error")

    displayError: (errData) ->
      @add('danger', @getMessage(errData))

    storeErrorForDisplay: (errData) ->
      @addCache('danger', @getMessage(errData))
