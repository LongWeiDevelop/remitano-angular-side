'use strict'

angular.module 'remitano'
  .factory 'AuthInterceptor', ($q, $injector, $translate, i18n, RAILS_ENV, CDN_HOST, $window) ->
    request: (config) ->
      external = config.url.startsWith("http:") || config.url.startsWith("https:")
      return config if external

      token = $injector.get('Auth').getToken()
      ssoToken = $injector.get('Auth').getSsoToken()
      config.headers = config.headers or {}
      if token
        config.headers.Authorization = "Bearer #{token}"
      if ssoToken
        config.headers.Sso = "Bearer #{ssoToken}"
      config.headers.Country = i18n.country()
      config.headers.Lang = i18n.locale()
      config.headers.Coin = RAILS_ENV.coin_currency
      config.headers.Mode = RAILS_ENV.mode
      config.headers.MOBILE_PLATFORM = $window.MOBILE_PLATFORM
      config.headers.MOBILE_IDENTIFIER = $window.MOBILE_IDENTIFIER
      config.headers.MOBILE_DIST_TYPE = $window.MOBILE_DIST_TYPE
      config.headers.MOBILE_APP_VERSION = $window.MOBILE_APP_VERSION
      if config.url.startsWith "/api/"
        config.headers["X-Device-Uuid"] = $.jStorage.get('device_uuid')
      config
    responseError: (response) ->
      if (response.status == 401) && (response.config.url != "/api/v1/users/me")
        $injector.get('Auth').logout("AuthInterceptor:responseError")
        console.error("Unauthorized")
        $injector.get('$state').go('root.login')
      $q.reject(response)

  .config ($httpProvider) ->
    $httpProvider.interceptors.push('AuthInterceptor')
