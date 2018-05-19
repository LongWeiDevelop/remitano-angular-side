'use strict'

angular.module("remitano").directive "numericInput", ->
  restrict: "A"
  link: (scope, element, attrs, ngFormCtrl) ->
    ua = navigator.userAgent.toLowerCase()
    isAndroid = ua.indexOf("android") > -1
    unless isAndroid
      element.attr('type', 'number')
