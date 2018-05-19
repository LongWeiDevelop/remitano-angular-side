'use strict'

angular.module 'remitano'
.controller 'CareersController',
(RAILS_ENV) ->
  vm = @
  init = ->
    vm.currentPage = "careers"
    vm.country = RAILS_ENV.current_country

    return

  init()
  return
