'use strict'

angular.module 'remitano'
.controller 'PolicyController',
($stateParams, $templateCache) ->
  vm = @

  init = ->
    vm.countryCodeFile = countryCodeFile
    vm.currentPage = currentPage
    return

  countryCodeFile = ->
    countryCode = $stateParams.country
    countryCode = "vi" if countryCode == "vn"
    templateUrl = "policy/#{$stateParams.page}/#{countryCode}.tmpl.html"
    return templateUrl if $templateCache.get(templateUrl)
    "policy/#{$stateParams.page}/en.tmpl.html"

  currentPage = ->
    $stateParams.page

  init()
  return
