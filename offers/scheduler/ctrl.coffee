'use strict'

angular.module 'remitano'
.controller 'OfferSchedulerController', ($uibModalInstance, Auth, offer, Offer) ->
  vm = this
  init = ->
    vm.offer = offer
    vm.moments = ["on1", "off1", "on2", "off2"]
    vm.timeZone = moment().format("Z")
    vm.update = update
    vm.close = -> $uibModalInstance.dismiss('close')
    vm.updating = 0

  update = ->
    vm.updating += 1
    vm.updateFailed = false
    params = {}
    params[key] = value for key, value of vm.offer when key in vm.moments.concat(['scheduled'])
    Offer.update({ id: vm.offer.id }, params).$promise.catch(updateError).finally -> vm.updating -= 1

  updateError = ->
    vm.updateFailed = true

  init()
  return

