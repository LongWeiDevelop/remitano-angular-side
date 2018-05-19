'use strict'

angular.module 'remitano'
  .service 'SeoHeaderBuilder', ($translate, RAILS_ENV, PaymentMethodTranslate) ->
    {
      headerTitle: (key, params) ->
        if key == "cano_title_root_offers"
          @headerTitleOffers(key, params)
        else if key == "cano_title_fiatWallet"
          $translate.instant("cano_title_fiatWallet", currency: RAILS_ENV.current_currency)
        else if params["page"]
          $translate.instant("cano_title_root_#{params["page"]}", params)
        else
          $translate.instant(key, params)

      headerTitleOffers: (params) ->
        if params.payment_method && params.country
          $translate.instant(key,
            payment_method: PaymentMethodTranslate.instant(params.payment_method),
            country_name: RAILS_ENV.country_names[params.country])
        else
          $translate.instant("cano_title_root_offers", params)

    }

