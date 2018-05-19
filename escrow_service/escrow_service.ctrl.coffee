'use strict'

angular.module 'remitano'
.controller 'EscrowServiceController',
($sce, $stateParams, RAILS_ENV) ->
  vm = @
  init = ->
    vm.currentPage = "escrowService"
    vm.country = RAILS_ENV.current_country
    url = RAILS_ENV.country_video_urls[$stateParams.country]
    if !_.isEmpty(url)
      vm.videoSrc = ""
      if url.indexOf("youku") != -1
        vm.videoSrc = "youku"
        vm.videoUrl = $sce.trustAsResourceUrl(url)
      else if videoId = Util.youtubeId(url)
        vm.videoUrl = $sce.trustAsResourceUrl("//www.youtube.com/embed/#{videoId}?hl=#{$stateParams.lang}&cc_lang_pref=#{$stateParams.lang}&rel=0&cc_load_policy=1&showinfo=0&controls=0")
            
  init()
  return
