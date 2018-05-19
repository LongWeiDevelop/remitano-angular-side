'use strict'

angular.module 'remitano'
.factory 'actionConfirmationRedirector', ($state, $translate, Flash, RAILS_ENV) ->
  actionConfirmationRedirector =
    redirect: (actionConfirmation) ->
      method = if actionConfirmation.actionable_type == "PaymentOperation"
        "add"
      else
        "addCache"

      if actionConfirmation.status == "confirmed"
        Flash[method]('success', $translate.instant("action_confirmed_successfully"))
      else if actionConfirmation.status == "error"
        Flash[method]('danger', actionConfirmation.status_explanation)

      switch actionConfirmation.actionable_type
        when "TransferRemiOperation" then $state.go("root.remiWallet")
        when "PaymentOperation"
          unless RAILS_ENV.env == "test"
            window.location = actionConfirmation.actionable.merchant_payment_url
        when "Trade" then $state.go("root.trade", ref: actionConfirmation.actionable.ref)
        when "CoinWithdrawal" then $state.go("root.coinWallet.withdrawal")
        when "FiatWithdrawal" then $state.go("root.fiatWallet.withdrawal")
        when "OfferCreateRequest", "OfferUpdateRequest"
          $state.go("root.offerDetails", id: actionConfirmation.actionable.offer_id, canonical_name: actionConfirmation.actionable.offer_canonical_name)
        when "TradeCreateRequest"
          if actionConfirmation.status == "confirmed"
            $state.go("root.trade", {ref: actionConfirmation.actionable.trade_ref})
          else
            $state.go("root.offerDetails", {id: actionConfirmation.actionable.offer_id, canonical_name: actionConfirmation.actionable.offer_canonical_name})
        when "FiatWithdrawalDetail" then $state.go("root.fiatWallet.withdrawal")
