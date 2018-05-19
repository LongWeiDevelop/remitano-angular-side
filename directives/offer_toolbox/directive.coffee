'use strict'

angular.module 'remitano'
.directive 'offerToolbox', ->
  restrict: 'E'
  replace: true
  scope:
    offer: "<"
    textClass: "@"
    onDeleted: "&"
  templateUrl: 'directives/offer_toolbox/tmpl.html'
  controllerAs: 'vm'
  bindToController: true
  controller: (Offer, Flash, $translate, dialogs, OfferSchedulerService) ->
    vm = this

    init = ->
      vm.enable = enable
      vm.disable = disable
      vm.remove = remove
      vm.deleting = false
      vm.scheduledStatus = -> $translate.instant(if vm.offer?.scheduled then "on" else "off")
      vm.schedule = schedule

    removeSuccess = ->
      vm.deleting = false
      addMethod = if vm.onDeleted? then "addCache" else "add"
      Flash[addMethod]("success", $translate.instant("offer_deleted"), true)
      vm.onDeleted?()
      vm.offer.deleted = true

    removeError = ->
      Flash.clear()
      Flash.add("danger", $translate.instant("offer_cant_delete"), true)
      vm.deleting = false

    schedule = ->
      OfferSchedulerService.request(vm.offer)

    remove = ->
      offer = new Offer(vm.offer)
      dialog = dialogs.confirm($translate.instant("other_confirmation"), $translate.instant("are_you_sure"))
      dialog.result.then (btn) ->
        vm.deleting = true
        offer.$remove({}, removeSuccess, removeError)

    enable = ->
      offer = new Offer(vm.offer)
      vm.toggling = true
      offer.$enable( ->
        vm.offer.disabled = false
        vm.toggling = false
      , (res) ->
        Flash.displayError(res.data)
        vm.toggling = false
      )

    disable = ->
      offer = new Offer(vm.offer)
      vm.toggling = true
      offer.$disable( ->
        vm.offer.disabled = true
        vm.toggling = false
      , (res) ->
        Flash.displayError(res.data)
        vm.toggling = false
      )

    init()
    return
