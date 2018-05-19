'use strict'

angular.module 'remitano'
.config ($stateProvider, $urlRouterProvider, RAILS_ENV) ->
  $stateProvider.state 'root',
    url: "/{country:(?:#{RAILS_ENV.countries.join("|")})}{language:(?:|\-en)}"
    # url: '/root'
    abstract: true
    templateUrl: 'root/root.tmpl.html'
    controller: 'RootController as rvm'
    params:
      country: 'vn'
    data:
      head:
        keywords: ["mua", "ban", 'bitcoin', 'vietnam', 'san giao dich Bitcoin']
