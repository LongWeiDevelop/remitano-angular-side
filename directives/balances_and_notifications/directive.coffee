'use strict'

angular.module 'remitano'
.directive 'balancesAndNotifications', ->
  restrict: 'A'
  templateUrl: 'directives/balances_and_notifications/tmpl.html'
  scope:
    user: "="
    notifications: "="
    pendingNotificationCount: "="
    activeTradesCount: "="
    onNotificationsViewed: "&"
    onNotificationsRead: "&"
    viewAllNotifications: "&"
    compact: "="
  controllerAs: 'vm'
  bindToController: true
  controller: ($scope, $state, AccountManager) ->
    vm = this
    vm.viewAllNotifications = ->
      $state.go("root.notifications")

    vm.viewActiveTrades = ->
      $state.go("root.dashboard.escrow.trades", tradeStatus: 'active')

    $scope.$watch "vm.user", ->
      vm.fiatAccount = ->
        if vm.user
          AccountManager.currentFiatAccount()
        else
          null
      vm.coinAccount = ->
        if vm.user
          AccountManager.currentCoinAccount()
        else
          null

    return
