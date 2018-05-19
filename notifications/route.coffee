'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider
  .state 'root.notifications',
    url: '/notifications?page'
    templateUrl: 'notifications/tmpl.html'
    controller: 'NotificationsController as vm'
    reloadOnSearch: false
    data:
      access: AccessLevels.user
      title: 'cano_title_root_notifications'
      noSEO: true
