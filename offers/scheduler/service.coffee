'use strict'

angular.module 'remitano'
  .factory 'OfferSchedulerService', ($uibModal) ->
    request: (offer) ->
      uibModalInstance = $uibModal.open(
        templateUrl: 'offers/scheduler/tmpl.html'
        controller: 'OfferSchedulerController as vm'
        size: 'md'
        resolve:
          offer: -> offer
      )
