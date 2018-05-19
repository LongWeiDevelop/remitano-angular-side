'use strict'

angular.module 'remitano'
.directive 'profileSummary', ->
  restrict: "E"
  templateUrl: "trade/profile_summary/tmpl.html"
  transclude: true
  scope:
    profile: "="
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, $translate, $rootScope) ->
    vm = @
    vm.coin = $rootScope.coin_currency
    vm.tradedAmount = vm.profile.volume[vm.coin]
    vm.socialStatusText = (verified) ->
      translatedKey = if verified then "status_verified" else "status_empty"
      $translate.instant(translatedKey)
    return
