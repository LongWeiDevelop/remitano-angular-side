'use strict'

angular.module 'remitano'
.config ($stateProvider) ->
  $stateProvider
  .state 'root.profile',
    url: '/profile/{username:[a-z][a-z0-9_]+}'
    templateUrl: 'profile/profile.tmpl.html'
    data:
      title: 'main_title_profile'
