'use strict'

angular.module 'remitano'
.directive "messageItem", ($uibModal) ->
  restrict: "E"
  templateUrl: "trade/message_item/message_item.tmpl.html"
  scope:
    message: "="
    tradeRef: "="
    imageOnly: "="
  replace: true
  controllerAs: "vm"
  bindToController: true
  controller: ->
    vm = this
    vm.zoomImg = (message) ->
      uibModalInstance = $uibModal.open(
        templateUrl: 'trade/message_item/attachment_dialog.tmpl.html'
        controller: 'AttachmentController'
        size: 'lg'
        resolve:
          message: ->
            message
      )
    return
