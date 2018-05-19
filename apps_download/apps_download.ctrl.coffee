'use strict'

angular.module 'remitano'
.controller 'AppsDownloadController',
($scope, RAILS_ENV, MobileApp) ->
  vm = @
  init = ->
    setTimeout( ->
      document.body.scrollTop = document.documentElement.scrollTop = 0;
    , 100)
    vm.RAILS_ENV = RAILS_ENV
    vm.MobileApp = MobileApp
    return

  init()
  return
