'use strict'

angular.module 'remitano'
.controller 'FiatWalletWithdrawalController', (RAILS_ENV) ->
  vm = @
  init = ->
    vm.currency = RAILS_ENV.current_currency

  init()
  return
