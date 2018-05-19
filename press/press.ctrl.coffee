'use strict'

angular.module 'remitano'
.controller 'PressController',
($stateParams, Press, RAILS_ENV) ->
  vm = @
  vm.country = RAILS_ENV.current_country

  init = ->
    vm.chunkPresses = []
    vm.fetching = true
    vm.currentPage = "press"

    loadSuccess = (data) =>
      vm.chunkPresses = _.chunk(data, 2)
      vm.fetching = false

    loadError = (response) =>
      vm.errorFetching = true
      vm.fetching = false

    Press.details({}, loadSuccess, loadError)
    return

  init()
  return

