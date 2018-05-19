'use strict'

angular.module 'remitano'
.config ($stateProvider, $urlRouterProvider, RAILS_ENV) ->
  switch RAILS_ENV.mode
    when "swap"
      $stateProvider.state "root.landing",
        url: ""
        templateUrl: 'landing/swap.tmpl.html'
        controller: 'SwapLandingController as vm'
        data:
          noFlash: true
          head:
            seoTitle: ($translate, params) ->
              $translate.instant('cano_title_root_landing', country_name: RAILS_ENV.country_names[params.country])
            keywords: RAILS_ENV.country_keywords?[RAILS_ENV.current_country]
    else
      $stateProvider.state "root.landing",
        url: ""
        templateUrl: 'landing/landing.tmpl.html'
        controller: 'LandingController as vm'
        data:
          noFlash: true
          head:
            seoTitle: ($translate, params) ->
              $translate.instant('cano_title_root_landing', country_name: RAILS_ENV.country_names[params.country])
            keywords: RAILS_ENV.country_keywords?[RAILS_ENV.current_country]
