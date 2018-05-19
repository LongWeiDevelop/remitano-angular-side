'use strict'

angular.module 'remitano'
.directive 'blockchainAddress', () ->
  restrict: 'E'
  templateUrl: 'directives/blockchain_address/tmpl.html'
  scope:
    address: "="
    linkAsIcon: "="
  controllerAs: 'vm'
  bindToController: true
  controller: () ->
    vm = this

    init = ->
      vm.addressWbr = addressWbr()

    addressWbr = ->
      if vm.address?
        len = vm.address.length
        cutAt = len / 2
        parts = [vm.address[0..(cutAt-1)], vm.address[cutAt..len]]
        parts.join("<wbr/>")

    init()
    return
