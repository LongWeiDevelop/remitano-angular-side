'use strict'

angular.module 'remitano'
.directive "tradeFeedback", ->
  restrict: "E"
  templateUrl: "trade/trade_feedback/trade_feedback.tmpl.html"
  replace: true
  scope:
    tradeRef: "@"
    otherUser: "@"
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, Flash, Trade, $translate, MobileApp)->
    vm = this
    changeFeedbackContentTimeoutId = null

    init = ->
      vm.fetching = false
      vm.fetchFeedback = fetchFeedback
      vm.submitFeedback = submitFeedback
      vm.emoFromScore = emoFromScore
      vm.editingContent = false
      vm.newFeedback = {}
      vm.fetchFeedback().then ->
        vm.newFeedback.score = vm.feedback?.score
        vm.newFeedback.feedback_content = vm.feedback?.feedback_content
        vm.newFeedback.status = vm.feedback?.status
        $scope.$watch "vm.newFeedback.score", (score) ->
          if score != vm.feedback?.score
            submitFeedback()
            vm.editingContent = true

    emoFromScore = (score) ->
      switch score
        when "positive" then "icon-emo-happy"
        when "negative" then "icon-emo-angry"
        when "neutral" then "icon-emo-sleep"

    submitFeedback = ->
      return if vm.submitting
      vm.submitting = true
      vm.editingContent = false
      submitSuccess = (feedback) ->
        vm.feedback = feedback
        vm.changingFeedBack = false
        vm.submitting = false
        vm.errorMessage = null
        MobileApp.askForAppReview() if feedback.score == 'positive'

      submitError = (err) ->
        vm.errorMessage = err.data.error || $translate.instant("other_internal_server_error")
        vm.submitting = false

      vm.newFeedback.ref = vm.tradeRef
      Trade.postFeedback(vm.newFeedback, submitSuccess, submitError)

    fetchFeedback = ->
      vm.fetching = true
      vm.fetchError = false

      fetchFeedbackSuccess = (feedback) ->
        vm.fetching = false
        vm.fetchSuccess = true
        vm.feedback = feedback

      fetchFeedbackError = (err) ->
        vm.fetching = false
        vm.fetchError = true

      Trade.fetchFeedback(ref: vm.tradeRef, fetchFeedbackSuccess, fetchFeedbackError).$promise

    init()
    return
