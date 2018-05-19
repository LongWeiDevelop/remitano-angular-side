'use strict'

angular.module 'remitano'
.directive "blacklistTable", (Flash, $translate, dialogs, Blocking, Profile) ->
  restrict: "E"
  scope: {}
  templateUrl: "blacklist/blacklist.tmpl.html"
  controllerAs: "vm"
  replace: true
  controller: ($scope)->
    vm = @

    init = ->
      vm.onPageChanged = onPageChanged
      vm.removeBlocking = removeBlocking
      vm.pageChanged = onPageChanged
      onPageChanged()

    onPageChanged = (page) ->
      vm.fetching = true
      vm.errorFetching = false

      loadSuccess = (data) =>
        vm.blockings = data.blockings
        vm.paginationMeta = data.meta
        vm.fetching = false

      loadError = (response) =>
        Flash.clear()
        Flash.add("danger", $translate.instant('fetching_data_error'))
        vm.errorFetching = true
        vm.fetching = false

      Blocking.get {page: page}, loadSuccess, loadError

    removeBlocking = (blocking) ->
      vm.fetching = true
      vm.errorFetching = false

      onUpdateSuccess = (data) =>
        blocking.removed = true
        Flash.clear()
        Flash.add("success", $translate.instant('account_update_success'))
        vm.fetching = false

      onUpdateError = (response) =>
        Flash.clear()
        Flash.add("danger", $translate.instant('profile_error_blocking'))
        vm.errorFetching = true
        vm.fetching = false

      Profile.updateBlock(username: blocking.blockee_username, is_blocked: false, onUpdateSuccess, onUpdateError)

    init()
    return

