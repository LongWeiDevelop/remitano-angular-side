"use strict"

angular.module "remitano"
.config ($stateProvider, AccessLevels) ->
  $stateProvider
  .state "root.remittance",
    url: "/remittances"
    abstract: true
    templateUrl: "remittance/layout.tmpl.html"
    controller: 'RemittanceController as rvm'
