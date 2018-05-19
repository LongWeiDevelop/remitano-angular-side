'use strict'

angular.module 'remitano'
.directive "featuredTradeFeedbacks", (TradeFeedBack) ->
  restrict: "E"
  scope: {}
  templateUrl: "landing/featured_trade_feedbacks/tmpl.html"
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, $window, $timeout, $translate, bootstrapToolkit) ->
    vm = this
    init = ->
      vm.fetchPage = fetchPage
      vm.emoFromScore = emoFromScore
      vm.feedbackContent = feedbackContent
      hookBootstrapResized()
      fetchPage()

    bootstrapResized = ->
      vm.bootstrapBreakpoint = bootstrapToolkit.currentBreakpoint
      sliceFeedbacks()
      $scope.$evalAsync()

    hookBootstrapResized = ->
      $scope.$on 'bootstrap-resize', bootstrapResized
      bootstrapResized()

    fetchPage = (page) ->
      vm.fetching = true
      TradeFeedBack.featured({page: page}, loadSuccess).$promise.finally ->
        vm.fetching = false

    emoFromScore = (score) ->
      switch score
        when "positive" then "icon-emo-happy"
        when "negative" then "icon-emo-angry"
        when "neutral" then "icon-emo-sleep"

    loadSuccess = (data) ->
      vm.feedbacks = data.trade_feed_backs
      sliceFeedbacks()
      vm.paginationMeta = data.meta

    feedbackContent = (feedback) ->
      content = feedback.translations[$translate.use()]
      content ||= feedback.feedback_content

    sliceFeedbacks = ->
      vm.chunkedFeedbacks = if vm.feedbacks?
        sliceSize = switch vm.bootstrapBreakpoint
          when "xs" then 1
          when "sm" then 2
          when "md" then 3
          when "lg" then 4

        _.chunk(vm.feedbacks, sliceSize)
      else
        []

    init()
    return

