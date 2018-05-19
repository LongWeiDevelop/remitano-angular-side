'use strict'

angular.module 'remitano'
.controller 'RemittanceHistoryController', (Remittance, RAILS_ENV) ->
  vm = @
  init = ->
    vm.fetchRemittances = fetchRemittances
    vm.pageChanged = fetchRemittances
    fetchRemittances()

  fetchRemittancesError = ->
    delete vm.remittances
    vm.fetchError = true

  fetchRemittancesSuccess = (data) ->
    vm.remittances = data.remittances
    vm.paginationMeta = data.meta

  fetchRemittances = (page) ->
    vm.fetching = true
    vm.fetchError = false
    promise = Remittance.query(page: page).$promise
    promise.then(fetchRemittancesSuccess, fetchRemittancesError).finally -> vm.fetching = false

  init()
  return
