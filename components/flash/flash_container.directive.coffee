'use strict'

angular.module 'remitano'
.directive 'flashContainer', () ->
  restrict: 'E'
  templateUrl: 'components/flash/flash.tmpl.html'
  scope: { }
  replace: true
  controllerAs: 'vm'
  controller: ($scope, $translate, $state, Flash, Auth, AccountManager) ->
    vm = @
    init = ->
      vm.$state = $state
      vm.Flash = Flash
      recalculate()
      $scope.$on 'coinAccount:updated', recalculateCallToAuthy
      $scope.$on 'userReloaded', recalculate
      $scope.$on 'userLoggedOut', recalculate

    calculateCallToAuthy = ->
      user = Auth.currentUser()
      return false unless user?
      return false if user.two_factor_enabled
      return false if $state.current.name == "root.settings2"
      return true if AccountManager.currentCoinAccount().balance > 0
      return true if AccountManager.currentFiatAccount()?.balance > 0
      false

    recalculateCallToAuthy = ->
      vm.callToAuthy = calculateCallToAuthy()

    calculatePhoneWarn = ->
      Auth.currentUser()?.phone_warn

    recalculatePhoneWarn = ->
      vm.phoneWarn = calculatePhoneWarn()

    calculateAccessLimited = ->
      vm.accessLimited = Auth.currentUser()?.status == "limited"
      if vm.accessLimited
        vm.needVerifyDocument = !_.includes(["verified", "unverified"], Auth.currentUser().doc_status)
        vm.needVerifyPhone = Auth.currentUser().phone_number_status != "verified"
        vm.needEnableTwoFactor = Auth.currentUser().two_factor_enabled == false
        vm.requireUserAction = vm.needVerifyDocument || vm.needVerifyPhone || vm.needEnableTwoFactor

    recalculate = ->
      recalculateCallToAuthy()
      recalculatePhoneWarn()
      calculateAccessLimited()

    init()

    return

