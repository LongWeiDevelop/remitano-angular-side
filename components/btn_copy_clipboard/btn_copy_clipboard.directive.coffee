'use strict'

angular.module 'remitano'
.directive 'btnCopyClipboard', ($translate, toaster) ->
  restrict: 'E'
  templateUrl: 'components/btn_copy_clipboard/btn_copy_clipboard.tmpl.html'
  replace: true
  scope:
    text: "@"
    tooltip: "@"
  controllerAs: "vm"
  bindToController: true
  controller: ($scope) ->
    vm = @
    init = ->
      vm.onCopySuccess = onCopySuccess
      return

    onCopySuccess = (e) ->
      toaster.pop(
        type: 'info'
        title: $translate.instant("copied_to_clipboard")
        timeout: 3000
      )
      return

    init()
    return
