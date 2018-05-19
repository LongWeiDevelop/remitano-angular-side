'use strict'

angular.module 'remitano'
.directive "uploadDocuments", ->
  restrict: "E"
  templateUrl: "trade/upload_documents/upload_documents.tmpl.html"
  scope:
    tradeRef: "="
    messages: "="
    buttonKlass: "="
  replace: true
  controllerAs: "vm"
  bindToController: true
  controller: ($scope, Upload, Message, dialogs, $translate, RAILS_ENV, MobileApp) ->
    vm = this
    init = ->
      vm.uploading = false
      vm.fileSelected = fileSelected
      vm.progress = 0
      vm.dropAvailable = true
      vm.onAndroidUpload = onAndroidUpload
      vm.MobileApp = MobileApp
      vm.buttonKlass = vm.buttonKlass || 'btn-default'
      if RAILS_ENV.env == "test"
        vm.onSelectFile = (element) ->
          fileSelected(element.files[0])

    fileSelected = ($file, a, b) ->
      return if !$file || $file.length < 1
      Upload.upload(
        url: "/api/v1/messages/"
        fields: {trade_ref: vm.tradeRef}
        file: $file
      ).progress( (evt) ->
        vm.uploading = true
        vm.progress = parseInt(100.0 * evt.loaded / evt.total)
      ).success( (data, status, headers, config) ->
        message = new Message(data)
        vm.messages.unshift(message)
        vm.uploading = false
        vm.progress = 0
      ).error( (data) ->
        vm.uploading = false
        dialogs.error($translate.instant("other_error"), data.error)
      )

    onAndroidUpload = () ->
      MobileApp.uploadTradeEvidence(vm.tradeRef)

    $scope.$watch 'vm.myFile', ($file) ->
      return if !$file || $file.length < 1
      fileSelected($file)

    init()
    return
