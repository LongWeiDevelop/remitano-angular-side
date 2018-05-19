angular.module("remitano").factory "localEquivalentOfBtc", ($stateParams, $filter, RAILS_ENV, RatesManager) ->
  localEquivalentOfBtc = (coinAmount) ->
    currency = RAILS_ENV.country_currencies[$stateParams.country] || "USD"
    crate = RAILS_ENV.currency_rates[currency]
    amount = coinAmount * RatesManager.currentExchangeRates()[RAILS_ENV.default_exchange] * crate

    if amount > 0
      scale = Math.floor(Math.log(amount) / Math.log(10)) - 1
      base = Math.pow(10,  scale)
      amount = (Math.round(amount / base) * base).toFixed(Math.max(0, - scale))
    "#{$filter("currencyFormatter")(amount, currency)} #{currency}"

