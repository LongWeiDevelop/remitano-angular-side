'use strict'
# https://github.com/w11k/w11k-angular-seo-header

angular.module 'angular-seo-header', []
angular.module('angular-seo-header').directive 'head',
  ($rootScope, $compile, $translate, SeoBridge, SeoHeaderBuilder, Auth, AccessLevels) ->
    html = '<title ng-if="head.title" ng-bind="head.title"></title>' +
    '<meta name="keywords" content="{{head.keywords}}" ng-if="head.keywords">' +
    '<meta name="description" content="{{head.description}}" ng-if="head.description">' +
    '<meta name="robots" content="{{head.robots}}" ng-if="head.robots">' +
    "<link rel='canonical' href='https://#{Auth.domain()}/{{head.canonical}}' ng-if='head.canonical'/>"
    {
      restrict: 'E'
      link: (scope, elem) ->
        elem.append $compile(html)(scope)
        scope.head = {}
        SeoBridge.subscribe (event, seoData) ->
          angular.extend(scope.head, seoData)

        $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
            # head data are available for upcoming view, directive jumps in:
          if !toState.data
            scope.head = {}
            return

          simpleHead = toState.data.access == AccessLevels.user
          simpleHead ||= toState.data.noSEO

          if simpleHead
            scope.head =
              title: $translate.instant(toState.data.title)
            return

          canonical = if toState.data.head.canonicalExtend
            toState.data.head.canonicalExtend(toState.data.head.canonical, toParams)
          else if toState.data.head.canonical
            toState.data.head.canonical
          else
            toState.url.remove("^").replace(/\?.*$/, "")

          title = if toState.data.head.title?
            toState.data.head.title
          else if toState.data.head.seoTitle?
            toState.data.head.seoTitle($translate, toParams)
          else
            $translate.instant(toState.data.title)

          description = if toState.data.head.description?
            $translate.instant(toState.data.head.description)
          else
            $translate.instant("cano_desc_#{toState.name.replace(/\./g,"_")}", toParams)

          keywords = if toState.data.head.keywordsExtend
            toState.data.head.keywordsExtend(toState.data.head.keywords, toParams)
          else
            toState.data.head.keywords

          scope.head =
            title: title
            keywords: if keywords then keywords.join(',') else false
            description: description
            robots: toState.data.head.robots
            canonical: toParams.country + canonical
          return
        return

    }
