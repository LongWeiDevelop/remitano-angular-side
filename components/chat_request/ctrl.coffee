'use strict'

angular.module 'remitano'
.controller 'ChatRequestController', ($scope, $uibModal) ->
  vm = this
  init = ->
    vm.requestChat = ->
      $uibModal.open(
        templateUrl: 'components/chat_request/dialog.tmpl.html'
        controller: 'ChatRequestDialogController as vm'
        size: 'md'
      )

  init()
  return
