'use strict'

angular.module 'remitano'
.controller "ExecutionsModalController",
($scope, $uibModalInstance, executions) ->
  $scope.executions = executions
  $scope.close = ->
    $uibModalInstance.close null
