'use strict'

angular.module 'remitano'
.directive "receivedFeedback", ->
  restrict: "E"
  templateUrl: "trade/received_feedback/received_feedback.tmpl.html"
  replace: true
  scope:
    otherUser: "="
    trade: "="
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, $translate)->
    vm = this
    init = ->
      vm.feedbackScore = feedbackScore
      vm.emoFromScore = emoFromScore

    emoFromScore = (score) ->
      switch score
        when "positive" then "icon-emo-happy"
        when "negative" then "icon-emo-angry"
        when "neutral" then "icon-emo-sleep"
        else "icon-emo-displeased"

    feedbackScore = (score) ->
      score ||= 'unrated'
      $translate.instant("trade_feedback_#{score}")

    init()
    return
