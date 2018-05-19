'use strict'

angular.module('remitano').controller 'ReferralProgramController', (Auth, $http, $stateParams, referralInformation) ->
  vm = @
  init = ->
    if Auth.currentUser()?
      vm.referral_url = "https://#{Auth.domain()}/#{$stateParams.country}?ref=#{Auth.currentUser().username}"
      $http.get("/api/v1/banners", params: { country_code: $stateParams.country }).success (banners) =>
        vm.banners = banners

  vm.Auth = Auth
  vm.referralProgram = referralInformation.program()
  vm.referralTranslation = referralInformation.translation()
  vm.referralReward = referralInformation.longReward()
  vm.referralMaxReward = referralInformation.longMaxReward()
  vm.referralMaxTimes = referralInformation.maxTimes()
  vm.referralGoal = referralInformation.referralGoal()

  init()
  return

