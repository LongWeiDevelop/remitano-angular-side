'use strict'

angular.module 'remitano'
.controller 'RemittanceCreateProceedController',
($scope, Remittance, Flash, $state, $translate, $analytics, RemittancePreparator, Auth, RAILS_ENV) ->
  vm = @

  init = ->
    vm.pendingRemittance = RemittancePreparator.getRemittance()
    createRemittance()

  createRemittance = ->
    return RemittancePreparator.goBack() unless vm.pendingRemittance?
    vm.creating = true
    Remittance.save vm.pendingRemittance, (data) ->
      vm.creating = false
      RemittancePreparator.cleanUp()
      if data.is_action_confirmation
        $state.go("root.actionConfirmationConfirm", id: data.id)
      else
        Flash.addCache('success', $translate.instant("remittance_created_successfully"), true)
        $analytics.eventTrack('createRemittance', {  category: 'remittance' })
        $state.go("root.remittance.show", ref: data.ref)
    , (err) ->
      vm.creating = false
      Flash.addCache('danger', err.data?.error || $translate.instant("other_something_went_wrong"))
      RemittancePreparator.goBack()

  init()
  return
