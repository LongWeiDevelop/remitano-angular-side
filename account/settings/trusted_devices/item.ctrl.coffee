'use strict'

angular.module 'remitano'
.directive "trustedDeviceItem", ->
  restrict: "E"
  replace: true
  templateUrl: "account/settings/trusted_devices/item.tmpl.html"
  scope:
    device: "<"
  controllerAs: 'vm'
  bindToController: true
  controller: (TrustedDevice) ->
    vm = @
    init = ->
      vm.delete = deleteDevice
      vm.clazz = clazz

    clazz = ->
      k = ["trusted-device-#{vm.device.id}"]
      if vm.deleted
        k.push "deleted"
      k

    deleteDevice = ->
      vm.deleteAsking = false
      return if vm.deleting
      vm.deleting = true
      TrustedDevice.delete(id: vm.device.id, deleteSuccess).$promise.finally -> vm.deleting = false

    deleteSuccess = (data) =>
      vm.deleted = true

    init()
    return
