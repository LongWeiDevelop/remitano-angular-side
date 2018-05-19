'use strict'

angular.module('remitano').controller 'OfferFormController', ($state) ->
  @offerId = $state.params.id
  return
