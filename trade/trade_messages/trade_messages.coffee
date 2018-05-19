'use strict'

angular.module 'remitano'
.directive "tradeMessages", (Message, dialogs, $location, $translate, Auth, SocketWrapper, RAILS_ENV) ->
  restrict: "E"
  templateUrl: "trade/trade_messages/trade_messages.tmpl.html"
  scope:
    tradeWithRole: "="
    imageOnly: "="
    chatDisabled: "="
  replace: true
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, $state) ->
    vm = this
    vm.messages = []
    init = ->
      vm.getMessages = getMessages
      vm.sendMessage = sendMessage
      vm.otherUser = vm.tradeWithRole.partner.username
      subscribeMessageChannel()
      getMessages()

    sendMessageSuccess = (message) ->
      message.animateClass = "fade-in"
      vm.messages.unshift(message)
      vm.sending = false
      vm.sendError = false
      vm.content = ""

    sendMessageError = (res) ->
      vm.sending = false
      vm.sendError = true
      dialogs.error("Error", res.data.error)

    sendMessage = ->
      if !vm.content
        return dialogs.error($translate.instant("other_error"), $translate.instant("message_cant_be_empty"))
      vm.sending = true
      vm.sendError = false
      message = {
        content: vm.content,
        trade_ref: vm.tradeWithRole.trade.ref
      }
      Message.save(message, sendMessageSuccess, sendMessageError)

    subscribeMessageChannel = () ->
      user_id = Auth.currentUser().id
      for event in ["new-#{RAILS_ENV.coin_currency}"]
        SocketWrapper.subscribe $scope, "private-user_#{user_id}@user_notifications_#{user_id}", event, handleNotification

    handleNotification = (event, data) ->
      if data.path == $location.path() && data.classification == "new_trade_message"
        getNewMessage()

    getMessageError = ->
      vm.fetching = false
      vm.fetchError = true

    getMessageSuccess = (data) ->
      vm.messages = data.messages
      vm.fetching = false
      vm.fetchError = false

    getMessages = ->
      vm.fetching = true
      vm.fetchError = false
      Message.query(trade_ref: vm.tradeWithRole.trade.ref, getMessageSuccess, getMessageError)

    getNewMessage = ->
      first_msg = vm.messages.first()
      if first_msg
        since_id = first_msg.id
      else
        since_id = 0

      Message.query({trade_ref: vm.tradeWithRole.trade.ref, since_id: since_id}
        , getNewMessageSuccess, getMessages)

    getNewMessageSuccess = (data) ->
      currentUserId = Auth.currentUser().id
      for message in data.messages
        if message.user_id == currentUserId
          message.animateClass = "fade-in"
        else
          message.animateClass = "fade-in from-other"
        vm.messages.unshift(message)

    init()
    return
