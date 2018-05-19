'use strict'

angular.module 'remitano'
.directive "fileUpload", ->
  restrict: "E"
  templateUrl: "file_upload/file_upload.tmpl.html"
  require: ['ngModel']
  scope:
    path: "@"
    ngPreviewUrl: "="
    onSuccess: "&"
  replace: true
  controllerAs: "vm"
  bindToController: true
  link: (scope, element, attr, [ngModelCtrl]) ->
    scope.ngModelCtrl = ngModelCtrl

  controller: ($scope, Upload, Message, dialogs, $translate, RAILS_ENV, MobileApp) ->
    vm = this
    init = ->
      vm.handlerId = Math.random().toString(36).substring(2, 10)
      vm.uploading = false
      vm.fileSelected = fileSelected
      vm.progress = 0
      vm.dropAvailable = true
      vm.onAndroidUpload = onAndroidUpload
      vm.MobileApp = MobileApp
      if RAILS_ENV.env == "test"
        vm.onSelectFile = (element) ->
          fileSelected(element.files[0])

    fileSelected = ($file, a, b) ->
      return if !$file || $file.length < 1
      vm.uploading = true
      vm.progress = 0

      Upload.upload(
        url: vm.path
        file: $file
      ).progress( (evt) ->
        vm.progress = parseInt(100.0 * evt.loaded / evt.total)
      ).success( (data, status, headers, config) ->
        $scope.ngModelCtrl.$setViewValue(data.attachment_full_url)
        vm.ngPreviewUrl = data.attachment_thumb_url
        vm.uploading = false
        vm.onSuccess?($data: data)
      ).error( (data) ->
        vm.uploading = false
        dialogs.error($translate.instant("other_error"), data?.error)
      )

    $scope.$on('mobile_upload_image_done', (event, handlerId, result) ->
      if handlerId == vm.handlerId
        value = JSON.parse(result)
        $scope.ngModelCtrl.$setViewValue(value.attachment_full_url)
        vm.ngPreviewUrl = value.attachment_thumb_url
    )

    onAndroidUpload = () ->
      MobileApp.uploadImage(vm.handlerId)

    $scope.$watch 'vm.myFile', ($file) ->
      return if !$file || $file.length < 1
      fileSelected($file)

    init()
    return
