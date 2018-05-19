'use strict'

angular.module 'remitano'
.directive 'btcAddressInput', () ->
  restrict: 'E'
  templateUrl: 'directives/btc_address_input/tmpl.html'
  require: ['^form', 'ngModel']
  scope: {}
  controllerAs: 'vm'
  bindToController: true
  controller: (Auth, User, $q, $timeout, $http, RAILS_ENV, $rootScope) ->
    vm = this
    init = ->
      vm.isValidCoinAddress = (address) ->
        $rootScope.ADDRESS_PATTERN.test(address)

      vm.loadRecentAddresses = loadRecentAddresses

    loadRecentAddresses = (viewValue) ->
      return [] if viewValue? && viewValue.length > 0
      if (user = Auth.currentUser())
        if vm.recentAddresses?
          vm.recentAddresses
        else
          return vm.defer.promise if vm.defer?
          vm.defer = $q.defer()
          User.recentUsedBtcAddresses(loadSuccess, loadError)
          vm.defer.promise
      else
        []

    loadSuccess = (data) ->
      vm.recentAddresses = data
      vm.defer.resolve(vm.recentAddresses)

    loadError = ->
      vm.defer.reject()

    init()
    return

  link: (scope, element, attr, [form, ngModel]) ->
    scope.form = form
    scope.$watch 'vm.btcAddress', (value) ->
      ngModel.$setViewValue(value)
