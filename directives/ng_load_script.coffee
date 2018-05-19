'use strict'

executeJsFile = (jsFileUrl) ->
  js = document.createElement('script')
  js.setAttribute 'type', 'text/javascript'
  js.src = jsFileUrl
  document.body.appendChild js
  return

executeCssFile = (cssFileUrl) ->
  link = document.createElement('link')
  link.rel = 'stylesheet'
  link.type = 'text/css'
  link.href = cssFileUrl
  link.media = 'all'
  document.body.appendChild link
  return

angular.module('remitano')
.directive 'script', ->
  restrict: 'E'
  scope: false
  link: (scope, elem, attr) ->
    if attr.type == 'text/javascript-lazy'
      if jsFilePath = elem.attr("src")
        window.loadedJses ||= []
        return if window.loadedJses.indexOf(jsFilePath) != -1
        window.loadedJses.push jsFilePath
        executeJsFile(jsFilePath)
      else
        code = elem.text()
        f = new Function(code)
        f()
    return

angular.module('remitano')
.directive 'link', ->
  restrict: 'E'
  scope: false
  link: (scope, elem, attr) ->
    if attr.type == 'text/css-lazy' && cssFilePath = elem.attr("href")
      window.loadedCsses ||= []
      return if window.loadedCsses.indexOf(cssFilePath) != -1
      window.loadedCsses.push cssFilePath
      executeCssFile(cssFilePath)
    return

