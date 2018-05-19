'use strict'

angular.module 'remitano'
  .factory 'RemittanceRateFormatter', (CURRENCY_PRECISION) ->
    format: (remittance, receivingAmount) ->
      return unless remittance.sending_amount?
      return unless remittance.sending_amount > 0
      return unless receivingAmount?
      rates = if receivingAmount > remittance.sending_amount * 2
        [1, (receivingAmount * 1.0 / remittance.sending_amount).toFixed(CURRENCY_PRECISION[remittance.to_country_code])]
      else
        [(remittance.sending_amount * 1.0 / receivingAmount).toFixed(CURRENCY_PRECISION[remittance.from_country_code]), 1]
      rates.join(" : ")

