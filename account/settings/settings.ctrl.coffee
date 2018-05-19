'use strict'

angular.module 'remitano'
.controller 'SettingsController',
($scope, Auth, $state, $stateParams, MobileApp) ->
  vm = @
  init = ->
    vm.isIos = MobileApp.ios()
    if $stateParams.section?
      vm["is_#{$stateParams.section}_open"] = true
    else
      if Auth.currentUser().two_factor_enabled
        vm.is_profile_open = true
      else
        vm.is_two_factor_open = true

    for type in ["two_factor", "touch_id", "profile", "notification", "trusted_devices", "blacklist", "recent_used_ips"]
      $scope.$watch("vm.is_#{type}_open", watchAccordion.bind(null, type))

  watchAccordion = (type, value) ->
    $state.go("root.settings2", { section: type }, notify: false) if value
    vm["is_#{type}_ever_opened"] ||= value

  init()
  return
