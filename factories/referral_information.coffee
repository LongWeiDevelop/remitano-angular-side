angular.module("remitano").factory "referralInformation", ($stateParams, RAILS_ENV, Auth, localEquivalentOfBtc) ->
  factory =
    program: ->
      if Auth.isLoggedIn()
        Auth.currentUser().referral_program
      else
        RAILS_ENV.country_ref_programs[$stateParams.country]

    translation: ->
      switch (prog = @program())
        when "one_dollar_per_trade", "forty_cent_per_trade" then "two_sides"
        else prog

    reward: ->
      switch @program()
        when "one_time_at_two_btc" then localEquivalentOfBtc(COIN_CURRENCY_CONFIG.bonus_amounts[RAILS_ENV.coin_currency])
        when "forty_cent_per_trade" then localEquivalentOfBtc(0.0004)
        when "one_dollar_per_trade" then localEquivalentOfBtc(0.001)

    longReward: ->
      switch @program()
        when "one_time_at_two_btc" then "#{COIN_CURRENCY_CONFIG.bonus_amounts[RAILS_ENV.coin_currency]} #{RAILS_ENV.COIN_CURRENCY} (~ #{localEquivalentOfBtc(COIN_CURRENCY_CONFIG.bonus_amounts[RAILS_ENV.coin_currency])})"
        when "forty_cent_per_trade" then "0.0004 #{RAILS_ENV.COIN_CURRENCY} (~ #{localEquivalentOfBtc(0.0004)})"
        when "one_dollar_per_trade" then "0.001 #{RAILS_ENV.COIN_CURRENCY} (~ #{localEquivalentOfBtc(0.001)})"

    longMaxReward: ->
      switch @program()
        when "one_time_at_two_btc" then "#{COIN_CURRENCY_CONFIG.bonus_amounts[RAILS_ENV.coin_currency]} #{RAILS_ENV.COIN_CURRENCY} (~ #{localEquivalentOfBtc(COIN_CURRENCY_CONFIG.bonus_amounts[RAILS_ENV.coin_currency])})"

    maxTimes: ->
      switch @program()
        when "forty_cent_per_trade" then 10
        when "one_dollar_per_trade" then 5

    referralGoal: ->
      switch @program()
        when "one_time_at_two_btc" then COIN_CURRENCY_CONFIG.referral_goals[RAILS_ENV.coin_currency]

