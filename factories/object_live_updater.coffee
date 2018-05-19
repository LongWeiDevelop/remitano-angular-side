'use strict'

# use this to listen for changes in combination with rails CanLiveBroadcast concern
angular.module 'remitano'
  .service 'ObjectLiveUpdater', (SocketWrapper, $rootScope, Auth) ->
    class ObjectLiveUpdater
      @lookup: {}
      @singleton: (type) ->
        @lookup[type] ||= new ObjectLiveUpdater(type)
      constructor: (type) ->
        @type = type
        @_modelDict = {}
        $rootScope.$on '$stateChangeStart', =>
          @unsubscribeFiatWithdrawalUpdates()
          @clear()

      add: (model) ->
        @subscribeFiatWithdrawalUpdates()
        @_modelDict[model.id] = model
        this

      addAll: (models) ->
        for model in models
          @add(model)
        this

      clear: ->
        @_modelDict = {}
        this

      subscribable: ->
        return Auth.currentUser()?

      channel: ->
        userId = Auth.currentUser().id
        "private-user_#{userId}@#{@type}"

      subscribeFiatWithdrawalUpdates: ->
        unless @subscribed
          @subscribed = true
          return unless @subscribable()
          SocketWrapper.subscribe $rootScope, @channel(), "updated", @handleFiatWithdrawalUpdated.bind(this)

      unsubscribeFiatWithdrawalUpdates: ->
        if @subscribed
          @subscribed = false
          return unless @subscribable()
          SocketWrapper.unsubscribe $rootScope, @channel(), "updated"

      handleFiatWithdrawalUpdated: (event, data) ->
        model = data[@type]
        if @_modelDict[model.id]?
          angular.extend(@_modelDict[model.id], model)
