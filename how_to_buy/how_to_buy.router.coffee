'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider.state 'root.howToBuy',
    url: '/how-to-buy-bitcoin'
    templateUrl: 'how_to_buy/how_to_buy.tmpl.html'
    controller: "HowToBuyController"
    controllerAs: "vm"
    data:
      title: 'main_title_howtobuy'
