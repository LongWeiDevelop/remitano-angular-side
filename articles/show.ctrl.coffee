'use strict'

angular.module 'remitano'
.controller 'ArticleShowController', ($stateParams, Article, DynamicTitle, SeoBridge, $analytics) ->
  vm = @
  init = ->
    vm.fetchArticle = fetchArticle
    fetchArticle()

  fetchArticleSuccess = (data) ->
    vm.fetching = false
    vm.fetchError = false
    vm.article = data
    DynamicTitle.setTranslated(vm.article.title)
    SeoBridge.publish(title: vm.article.title, keywords: vm.article.keywords)
    trade = new Article
    data =
      alias: $stateParams.id
      category: 'article'
      label: 'view'
    $analytics.eventTrack('viewArticle', data)

  fetchArticleError = ->
    vm.fetching = false
    vm.fetchError = true

  fetchArticle = ->
    vm.fetching = true
    vm.fetchError = false
    Article.get({id: $stateParams.id}, fetchArticleSuccess, fetchArticleError)

  init()
  return
