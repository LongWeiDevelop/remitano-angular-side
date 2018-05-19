'use strict'

angular.module 'remitano'
.directive 'footer', () ->
  restrict: 'E'
  templateUrl: 'components/footer/footer.tmpl.html'
  controllerAs: 'vm'
  controller: ($stateParams, $window, MobileApp, Intercom, RAILS_ENV) ->
    vm = @
    init = ->
      vm.locale = $stateParams.lang
      vm.openLiveChat = openLiveChat
      vm.isMobileApp = isMobileApp
      vm.scrollToTop = scrollToTop
      vm.country = RAILS_ENV.current_country
      vm.MobileApp = MobileApp

    openLiveChat = ->
      Intercom.show() unless MobileApp.exists()

    isMobileApp = ->
      MobileApp.exists()

    scrollToTop = ->
      $window.scrollTo(0, 110)
      true

    init()
    return
