'use strict'

angular.module 'remitano'
.controller 'FiatWalletController', ($stateParams, Auth) ->
  fiatvm = @

  init = ->
    fiatvm.country = $stateParams.country
    fiatvm.recalculateMode = recalculateMode
    recalculateMode()

  recalculateMode = ->
    fiatvm.mode = calculateMode()

  calculateMode = ->
    if Auth.hasFiatWallet()
      "use"
    else
      "pre_use"

  init()
  return
