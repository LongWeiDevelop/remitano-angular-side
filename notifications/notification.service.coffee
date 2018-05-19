'use strict'

angular.module 'remitano'
.factory 'Notification', ($resource, $state, MobileApp, $rootScope) ->
  Notification = $resource '/api/v1/notifications/:id/:action',
    id: '@id'
  ,
    query:
      method: 'GET'
      isArray: false
    markAsRead:
      method: 'POST'
      params:
        action: 'mark_as_read'
    markAllAsViewed:
      method: 'POST'
      params:
        action: 'mark_all_as_viewed'
    markAllAsRead:
      method: 'POST'
      params:
        action: 'mark_all_as_read'

  Notification.saveJstorage = (pendingCount) ->
    $.jStorage.set 'pendingNotificationCount', pendingCount
    MobileApp.sendJstorage()
    $rootScope.$broadcast("pendingNotificationCountChanged", pendingCount)

  Notification
