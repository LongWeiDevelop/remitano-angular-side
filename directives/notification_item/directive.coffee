'use strict'

ICON_MAP =
  new_trade: 'star-empty'
  new_trade_message: 'comment-empty'
  trade_cancelled: 'cancel'
  trade_cancelled_automatically: 'cancel'
  trade_paid: 'money'
  trade_disputed: 'exclamation'
  trade_released: 'check'
  trade_resolved: 'hammer'
  trade_payment_updated: 'info-circled'
  trade_rated_positive: 'emo-happy'
  trade_rated_neutral: 'emo-sleep'
  trade_rated_negative: 'emo-angry'
  trade_new_buy_trade: 'star-empty'
  trade_new_sell_trade: 'star-empty'

  remittance_deposit_cancelled_automatically: 'cancel'
  remittance_deposit_disputed: 'exclamation'
  remittance_deposit_released: 'check'
  remittance_deposit_resolved: 'hammer'
  remittance_deposit_rated_positive: 'emo-happy'
  remittance_deposit_rated_neutral: 'emo-sleep'
  remittance_deposit_rated_negative: 'emo-angry'

  remittance_withdraw_cancelled_automatically: 'cancel'
  remittance_withdraw_cancelled: 'cancel'
  remittance_withdraw_paid: 'money'
  remittance_withdraw_disputed: 'exclamation'
  remittance_withdraw_resolved: 'hammer'
  remittance_withdraw_rated_positive: 'emo-happy'
  remittance_withdraw_rated_neutral: 'emo-sleep'
  remittance_withdraw_rated_negative: 'emo-angry'

  incoming_remi: 'bitcoin'
  doc_status_rejected: 'doc'
  doc_status_approved: 'check'
  doc_status_account_verified: 'check'

ICON_COLOR_MAP =
  new_trade: 'green'
  new_trade_message: ''
  trade_cancelled: ''
  trade_cancelled_automatically: ''
  trade_paid: 'green'
  trade_disputed: 'red'
  trade_released: 'green'
  trade_resolved: 'green'
  trade_payment_updated: 'green'
  trade_rated_positive: 'green'
  trade_rated_neutral: ''
  trade_rated_negative: 'red'
  trade_new_buy_trade: 'green'
  trade_new_sell_trade: 'green'

  remittance_deposit_cancelled_automatically: ''
  remittance_deposit_disputed: 'red'
  remittance_deposit_released: 'green'
  remittance_deposit_resolved: 'green'
  remittance_deposit_rated_positive: 'green'
  remittance_deposit_rated_neutral: ''
  remittance_deposit_rated_negative: 'red'

  remittance_withdraw_cancelled: ''
  remittance_withdraw_cancelled_automatically: ''
  remittance_withdraw_paid: 'green'
  remittance_withdraw_disputed: 'red'
  remittance_withdraw_resolved: 'green'
  remittance_withdraw_rated_positive: 'green'
  remittance_withdraw_rated_neutral: ''
  remittance_withdraw_rated_negative: 'red'

  incoming_remi: 'green'
  doc_status_rejected: 'red'
  doc_status_approved: 'green'
  doc_status_account_verified: 'green'



angular.module 'remitano'
.directive 'notificationItem', ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/notification_item/tmpl.html'
  scope:
    notification: "="
  controllerAs: 'vm'
  bindToController: true
  controller: (Notification) ->
    vm = this
    classification = vm.notification.classification
    vm.icon = "icon-#{ICON_MAP[classification]} #{ICON_COLOR_MAP[classification]}"
    vm.markAsRead = ->
      return if vm.notification.status == "read"
      if vm.notification.status == 'pending'
        Notification.saveJstorage(Math.max(0, $.jStorage.get('pendingNotificationCount') - 1))
      vm.notification.status = "read"
      Notification.markAsRead(id: vm.notification.id)

    return
