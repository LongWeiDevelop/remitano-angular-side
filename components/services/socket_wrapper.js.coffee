'use strict'

angular.module("remitano").service "SocketWrapper", (Auth, $rootScope, RAILS_ENV, WEBSOCKET_HOST, $ngRedux) ->
  socket = io.connect(WEBSOCKET_HOST, transports: ['websocket'])
  socket.on 'connect', ->
    socket.on 'reconnect', (data) ->
      for channel in channels
        socket.emit('subscribe', {room: channel, token: Auth.getToken() })

  channels = []
  channelsCount = {}
  eventsCount = {}
  service =
    socket: socket
    reconnect: ->
      @socket.io.disconnect()
      @socket.io.connect()
      for channel in channels
        socket.emit('subscribe', channel)

    broadCast: (data) ->
      eventFullName = "socket:#{data.channel}:#{data.event}"
      # console.warn eventFullName, data
      $rootScope.$broadcast(eventFullName, data)
      $rootScope.$digest()
      $ngRedux.dispatch
        type: 'remitano/Utils/Socket/SOCKET_MESSAGE_RECEIVED'
        payload:
          data: data
          eventFullName: eventFullName


    subscribePrivate: (user_id, scope, channel, event, callback) ->
      channel = "private-user_#{user_id}@#{channel}"
      @subscribe(scope, channel, event, callback)

    subscribe: (scope, channel, event, callback) ->
      eventFullName = "socket:#{channel}:#{event}"
      # console.warn "subscribe", eventFullName
      if scope.$on
        scope.$off ||= {}
        scope.$off[eventFullName] = scope.$on eventFullName, callback

      channelsCount[channel] ||= 0
      channelsCount[channel] += 1
      eventsCount[eventFullName] ||= 0
      eventsCount[eventFullName] += 1

      if channelsCount[channel] == 1
        channels.push(channel)
        socket.emit('subscribe', {room: channel, token: Auth.getToken()})
        # console.warn "subscribe_channel", channel


      if eventsCount[eventFullName] == 1
        socket.on eventFullName, @broadCast

      if scope.$on
        scope.$on("$destroy", => @unsubscribe(scope, channel, event))

    unsubscribe: (scope, channel, event) ->
      eventFullName = "socket:#{channel}:#{event}"
      if  channelsCount[channel] > 0
        if scope.$on
          scope.$off[eventFullName]()
          channelsCount[channel] -= 1
        eventsCount[eventFullName] -= 1

      if eventsCount[eventFullName] == 0
        socket.removeListener(eventFullName, @broadCast)
        # console.warn "unsubscribe", eventFullName

      if channelsCount[channel] == 0
        socket.emit('unsubscribe', channel)
        # console.warn "unsubscribe_channel", channel
