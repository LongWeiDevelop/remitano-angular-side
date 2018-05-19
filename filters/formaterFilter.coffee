'use strict'

angular.module 'remitano'
.filter "capitalize", ->
  (input, all) ->
    (if (!!input) then input.replace(/([^\W_]+[^\s-]*) */g, (txt) ->
      txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
    ) else "")

.filter "currencyFormatter", (RAILS_ENV, CURRENCY_PRECISION, CURRENCY_FORMATS, COIN_CURRENCY_CONFIG) ->
  (input, currencyOrCountry, unitFormat = false, showDash = false, maxDefaultPrecision=false, stripInsignificantZeros=false) ->
    currency = if currencyOrCountry?.length == 2
      RAILS_ENV.country_currencies[currencyOrCountry]
    else
      currencyOrCountry

    currency = currency?.toUpperCase()
    currency ||= "USD"
    unless input?
      return "--" if showDash
      return input = 0
    input = parseFloat(input) if typeof(input) == "string"

    if COIN_CURRENCY_CONFIG.coin_currencies.indexOf(currency.toLowerCase()) != -1
      precision = COIN_CURRENCY_CONFIG.precision_digits[currency.toLowerCase()]
    else if currency == "VND"
      precision = 0
    else if CURRENCY_PRECISION[currency]
      precision = CURRENCY_PRECISION[currency]
    else
      precision = RAILS_ENV.remi_decimals
    precision = maxDefaultPrecision if maxDefaultPrecision && precision > maxDefaultPrecision

    currencySymbol =
      COIN_CURRENCY_CONFIG.symbols[currency?.toLowerCase()] || CURRENCY_FORMATS[currency?.toLowerCase()]?.symbol || "$"

    formattedBareInput = input.formatCurrency(precision, null, null, stripInsignificantZeros)

    if unitFormat == "symbol"
      if CURRENCY_FORMATS[currency]? && CURRENCY_FORMATS[currency].symbol_first == false
        "#{formattedBareInput}#{currencySymbol}"
      else
        "#{currencySymbol}#{formattedBareInput}"
    else if unitFormat == "full"
      "#{formattedBareInput} #{currency}"
    else
      formattedBareInput

.filter "safeCopyCurrencyFormatter", ($filter) ->
  (input, currency, unitFormat, showDash, precision) ->
    formatted = $filter('currencyFormatter')(input, currency, unitFormat, showDash, precision)
    parts = formatted.split(",")
    mappedParts = for part, index in parts
      if index < parts.length - 1
        "<span class='delimiterized'>#{part}</span>"
      else
        part
    "<span class='safe-copy-currency'>#{mappedParts.join("")}</span>"

.filter "priceFormatter", (RAILS_ENV) ->
  (price, currency, precision) ->
    currency = currency?.toUpperCase()
    return unless price?
    return unless currency?
    price = parseFloat(price) if typeof(price) == "string"
    precision ||= switch currency
      when 'VND', 'TZS', 'NGN' then 0
      when 'AUD' then 4
      when 'USD' then 4
      else 2
    precision = precision / 2 if price > 100
    "#{price.formatCurrency(precision)} #{currency}"

.filter "dateFormater", (RAILS_ENV) ->
  (input, format) ->
    if input != undefined
      format = "LL" unless format
      moment(input).format(format)

.filter "dateTimeFromTimestamp", (RAILS_ENV) ->
  (input) ->
    if input != undefined && input != null
      moment(input).format(RAILS_ENV.date_time_format)


.filter 'isEmpty', ->
  (obj) ->
    for bar of obj
      `bar = bar`
      if obj.hasOwnProperty(bar)
        return false
    true

.filter 'shortTxId', ->
  (obj) ->
    return unless obj
    obj.substr(0, 6) + "..."
