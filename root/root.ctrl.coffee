'use strict'

angular.module('remitano').controller 'RootController',
($scope, $translate, RAILS_ENV, ngWatchCounter, digestDurationCounter, Configures, Auth, $state, $stateParams, $rootScope, MobileApp, $uibModal, $cookies, $timeout) ->
  rvm = @
  init = ->
    rvm.MobileApp = MobileApp
    rvm.RAILS_ENV = RAILS_ENV
    rvm.$state = $state
    $rootScope.country_code = $state.params.country
    $rootScope.currency_code = RAILS_ENV.country_currencies[$state.params.country]
    $rootScope.CURRENCY_CODE = $rootScope.currency_code?.toUpperCase()
    $rootScope.$on '$stateChangeStart', setPhoneSupport
    setPhoneSupport()
    showPartnerPopup()
    if RAILS_ENV.flashes != {}
      $timeout ->
        RAILS_ENV.flashes = null
      , 3000
    rvm.bootstrapClasses = {alert: "alert-danger", notice: "alert-success"}

  setPhoneSupport = ->
    rvm.hotline = RAILS_ENV.country_hotlines[$stateParams.country]
    rvm.hotline_link = if rvm.hotline?
      "tel://" + rvm.hotline.replace(/[^0-9]/g, "")
    else
      null

  showPartnerPopup = ->
    return unless RAILS_ENV.real_ip_country?
    return if RAILS_ENV.real_ip_country == "--"
    return if RAILS_ENV.country_partnered[RAILS_ENV.real_ip_country]
    return if $state.current.name == "root.partners"
    return if $.jStorage.get('displayedPartnersPopup')

    uibModalInstance = $uibModal.open(
      templateUrl: 'partners/popup.tmpl.html'
      controller: 'PartnersPopupController as vm'
      size: 'lg'
    )
    uibModalInstance.result.then(->
      $.jStorage.set("displayedPartnersPopup", 1)
    )

  if RAILS_ENV.angular_hint == "true"
    # Comment below line incase you want to stay away from Angular Digest Duration Counter module
    digestDurationCounter($scope)

    $scope.$watch ngWatchCounter, (newValue) ->
      $scope.watchCount = newValue
      clearTimeout(angular.watchOutTimeoutId)
      angular.watchOutTimeoutId = setTimeout ->
        console.groupCollapsed("Angular Watch Counter: #{$scope.watchCount}")
        for key, watchData of angular.elements
          console.group "#{key} - #{watchData.count}"
          for element in watchData.elements
            console.log element
          console.groupEnd()
        console.groupEnd()
      , 1000

  init()
  return
