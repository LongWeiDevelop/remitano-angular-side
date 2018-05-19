'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider
  .state 'root.dashboard.referrals', 
    url: '/dashboard/referrals'
    templateUrl: 'dashboard/referrals/referrals.tmpl.html'
    controller: 'DashboardReferralsController'
    controllerAs: 'vm'
    data:
      access: AccessLevels.user
      title: 'main_title_dashboard_referrals'
      head:
        canonical: "/dashboard/referrals"
