'use strict'

angular.module 'remitano'
.directive "exchangesIndexSection", ->
  restrict: "E"
  scope: {}
  templateUrl: "exchanges_index_section/tmpl.html"
  controllerAs: "vm"
  bindToController: true
  controller: ->
    vm = this
    vm.exchanges = {
      coinhills: "https://www.coinhills.com/market/exchange/"
      bitcoincharts: "https://bitcoincharts.com/markets/"
    }

    vm.exchangeUrls = for exchange, url of vm.exchanges
      "/exchange_index/#{exchange}.png"
    colSize = 12 / vm.exchangeUrls.length
    vm.colClass = "col-xs-#{colSize}"
    return
