'use strict'

angular.module 'remitano'
.directive "pressSection", ->
  restrict: "E"
  scope: {}
  templateUrl: "press/section/tmpl.html"
  controllerAs: "vm"
  bindToController: true
  controller: ->
    vm = this
    vm.presses = ["coindesk", "cointelegraph", "yahoo-finance"]
    vm.pressUrls = for press in vm.presses
      "/press/#{press}.png"
    colSize = 12 / vm.pressUrls.length
    vm.colClass = "col-xs-#{colSize}"
    return
