'use strict'

angular.module 'remitano'
.config ($stateProvider, $urlRouterProvider) ->
  $stateProvider
  .state 'root.referral_program',
    url: '/referral_program'
    templateUrl: 'referral_program/referral_program.tmpl.html'
    controller: 'ReferralProgramController as vm'
    data:
      title: 'main_title_referral_program'
      noFlash: true
      noSEO: true
