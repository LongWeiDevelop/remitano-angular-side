'use strict'

angular.module 'remitano'
.controller 'HomeController', ($scope, $http, $state) ->
  $state.go("root.landing")
