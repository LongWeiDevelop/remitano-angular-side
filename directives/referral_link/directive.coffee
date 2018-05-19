'use strict'

angular.module 'remitano'
.directive 'referralLink', ->
  restrict: 'E'
  scope: {}
  templateUrl: 'directives/referral_link/tmpl.html'
  controllerAs: 'vm'
  bindToController: true
  controller: ($stateParams, Auth, $window, RAILS_ENV) ->
    vm = this
    isChina = (RAILS_ENV.real_ip_country == "cn")

    if Auth.isLoggedIn()
      vm.referral_url = "https://#{Auth.domain()}/#{$stateParams.country}?ref=#{Auth.currentUser().username}"
      encodedUrl = $window.encodeURI(vm.referral_url)
      vm.socialNetworks = []
      if isChina
        vm.socialNetworks.push
          icon: "icon-weibo"
          url: "http://service.weibo.com/share/share.php?url=#{encodedUrl}&appkey=&title=#{encodedUrl}&pic=&ralateUid=&language=zh_cn"

        vm.socialNetworks.push
          icon: "icon-renren"
          url: "http://share.renren.com/share/buttonshare.do?link=#{encodedUrl}&title=#{encodedUrl}"
      else
        vm.socialNetworks.push
          icon: "icon-facebook-squared"
          url: "https://www.facebook.com/dialog/feed?app_id=117488185335202&display=popup&link=#{encodedUrl}"
        vm.socialNetworks.push
          icon: "icon-twitter-squared"
          url: "https://twitter.com/intent/tweet?text=#{encodedUrl}"

    return
