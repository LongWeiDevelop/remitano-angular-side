'use strict'

angular.module 'remitano'
.config ($stateProvider) ->
  $stateProvider
  .state 'root.home',
    url: '/'
    templateUrl: 'home/home.tmpl.html'
    controller: 'HomeController'
    data:
      title: 'other_home'
