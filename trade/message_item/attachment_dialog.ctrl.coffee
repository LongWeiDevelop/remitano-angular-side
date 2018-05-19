'use strict'

angular.module 'remitano'
.controller 'AttachmentController', ($scope, $uibModalInstance, message) ->
  $scope.message = message
  $scope.close = ->
    $uibModalInstance.dismiss('close')
