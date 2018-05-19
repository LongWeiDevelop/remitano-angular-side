angular.module('remitano').factory("Translate", ($translate) ->
  (scope) ->
    scope.placeholderText = (key) ->
      $translate.instant(key)
)

