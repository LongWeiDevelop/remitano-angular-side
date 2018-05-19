'use strict'

angular.module 'remitano'
.controller 'DashboardReferralsController', (Referrals, Auth) ->
  vm = @
  init = ->
    vm.loadReferrals = loadReferrals
    vm.pageChanged = pageChanged
    vm.filter = "all"
    vm.loadReferrals()

  loadReferrals = (options = {}) ->
    vm.fetching = true
    options.filter = vm.filter
    Referrals.query(options, loadReferralsSuccess, loadReferralsError)

  loadReferralsSuccess = (data) ->
    vm.fetching = false
    vm.errorFetchingReferrals = false
    vm.referrals = data.referrals
    vm.paginationMeta = data.meta
    vm.filters = data.meta.filters
    if vm.filters? && vm.filters.length > 0
      vm.hasStatus = true

  loadReferralsError = (data) ->
    vm.fetching = false
    vm.errorFetchingReferrals = true

  pageChanged = (page) ->
    loadReferrals(page: page)

  init()
  return
