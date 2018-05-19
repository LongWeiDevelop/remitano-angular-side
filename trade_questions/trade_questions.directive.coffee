'use strict'

angular.module 'remitano'
.directive 'tradeQuestions', () ->
  restrict: 'E'
  templateUrl: 'trade_questions/trade_questions.tmpl.html'
  scope:
    offerType: "="
