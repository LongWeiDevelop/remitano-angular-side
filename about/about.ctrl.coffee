'use strict'

angular.module 'remitano'
.controller 'AboutController',
(RAILS_ENV) ->
  vm = @
  init = ->
    vm.currentPage = "about"
    vm.country = RAILS_ENV.current_country
    return

  init()
  return
