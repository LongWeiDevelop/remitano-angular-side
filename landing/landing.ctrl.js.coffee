'use strict'

angular.module('remitano').controller 'LandingController', ($stateParams, $sce, RatesManager, $rootScope, Auth, $window, RAILS_ENV, referralInformation) ->
  vm = @
  init = ->
    vm.Auth = Auth
    url = RAILS_ENV.country_video_urls[$stateParams.country]
    if !_.isEmpty(url)
      vm.videoSrc = ""
      if url.indexOf("youku") != -1
        vm.videoSrc = "youku"
        vm.videoUrl = $sce.trustAsResourceUrl(url)
      else if videoId = Util.youtubeId(url)
        vm.videoUrl = $sce.trustAsResourceUrl("//www.youtube.com/embed/#{videoId}?hl=#{$stateParams.lang}&cc_lang_pref=#{$stateParams.lang}&rel=0&cc_load_policy=1&showinfo=0&controls=0")

    vm.coinBid = ->
      rates()?["#{RAILS_ENV.coin_currency}_bid"]

    vm.coinAsk = ->
      rates()?["#{RAILS_ENV.coin_currency}_ask"]

    vm.desktopView = ->
      $window.innerWidth >= 768

    rates = -> RatesManager.currentBtcRates()[$stateParams.country]
    vm.referralProgram = referralInformation.program()
    vm.referralTranslation = referralInformation.translation()
    vm.referralReward = referralInformation.reward()
    vm.referralMaxTimes = referralInformation.maxTimes()
    vm.referralGoal = referralInformation.referralGoal()

  init()
  return
