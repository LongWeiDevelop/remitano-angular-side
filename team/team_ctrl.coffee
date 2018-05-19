'use strict'

angular.module 'remitano'
.controller 'TeamController',
(TeamMember, RAILS_ENV) ->
  vm = @
  init = ->
    vm.currentPage = "team"
    vm.country = RAILS_ENV.current_country
    loadSuccess = (data) ->
      vm.teamMembersByTeam = {}
      for member in data
        vm.teamMembersByTeam[member.team] ||= []
        vm.teamMembersByTeam[member.team].push member
      return

    loadError = (data) ->
      return

    TeamMember.query({}, loadSuccess, loadError)

  init()
  return
