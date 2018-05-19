'use strict'

angular.module 'remitano'
.directive "profileForm", (Profile) ->
  restrict: "E"
  templateUrl: "account/settings/profile_form.tmpl.html"
  scope: {}
  controllerAs: 'vm'
  controller: ($rootScope, $scope, $injector, Auth, Flash, $translate, $stateParams, RAILS_ENV,
  dialogs, PhoneNumber, $filter, $http) ->
    vm = @
    return
