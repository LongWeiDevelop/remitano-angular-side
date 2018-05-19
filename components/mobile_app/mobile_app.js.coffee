'use strict'

angular.module('remitano')
.factory 'MobileApp', ($state, $window, $translate, $rootScope, i18n, $stateParams, RAILS_ENV, dialogs) ->
  MobileApp =
    exists: ->
      this.android() || this.ios()
    android: ->
      $window.MOBILE_PLATFORM == 'android'
    ios: ->
      $window.MOBILE_PLATFORM == 'ios'
    version: ->
      $window.MOBILE_APP_VERSION
    send: (action, message) ->
      if this.exists()
        this.postMessage(action + ":" + message)
    postMessage: (data) ->
      if this.ios()
        # https://github.com/facebook/react-native/blob/master/React/Views/RCTWebView.m
        $window.location = "react-js-navigation://postMessage?" +
          encodeURIComponent(String(data))
      else
        # https://github.com/facebook/react-native/blob/master/ReactAndroid/src/main/java/com/facebook/react/views/webview/ReactWebViewManager.java
        $window.__REACT_WEB_VIEW_BRIDGE.postMessage(String(data))

    setTitle: (title) ->
      this.send("CHANGE_TITLE", title)
    sendJstorage: ->
      this.send("SET_JSTORAGE", localStorage.getItem("jStorage"))
    uploadDocument: (docName, uploadPath) ->
      this.send("UPLOAD_DOCUMENT", docName) # version <= 1.7.3 TODO: remove later
      this.send("UPLOAD_DOCUMENT_WITH_PATH", "#{docName}::#{uploadPath}") # version > 1.7.3
    uploadTradeEvidence: (tradeRef) ->
      this.send("UPLOAD_TRADE_EVIDENCE", tradeRef)
    uploadImage: (handlerId, uploadPath) ->
      this.send("UPLOAD_IMAGE", handlerId)
      this.send("UPLOAD_IMAGE_WITH_PATH", "#{handlerId}::#{uploadPath}")
    sendLocaleData: ->
      key = $translate.use().toUpperCase().replace("-", "_") + '_LOCALES'
      this.send("SEND_LOCALE_DATA", i18n.nativeLocale() + ":" + JSON.stringify(Locale[key]))
    openExternalLink: (url) ->
      this.send("OPEN_EXTERNAL_LINK", url)
    enableTouchId: (secret) ->
      this.send("ENABLE_TOUCH_ID", secret)
    confirmWithTouchId: (message) ->
      this.send("CONFIRM_WITH_TOUCH_ID", message)
    confirmWithTouchIdWithoutToken: (message) ->
      this.send("CONFIRM_WITH_TOUCH_ID_WITHOUT_TOKEN", message)
    sendMenuItems: (menuItems) ->
      this.send("UPDATE_MENU_ITEMS", JSON.stringify(menuItems))
    checkTouchIdAvailability: () ->
      if this.ios()
        this.send("CHECK_TOUCH_ID_AVAILABILITY")
      else
        $rootScope.$broadcast("touch_id_availability", '')
    reloadCurrentPage: () ->
      this.send("RELOAD_CURRENT_PAGE")

    initWebViewBridge: ->
      document.addEventListener 'message', (e) ->
        message = e.data
        [action_with_column, action] = message.match(/(^.*?):/)
        value = message.replace(action_with_column, "")
        if action == "GOTO"
          if value == 'PAGE:active_trades'
            $state.go('root.dashboard.escrow.trades', {tradeStatus: 'active'})
          else if value == 'PAGE:closed_trades'
            $state.go('root.dashboard.escrow.trades', {tradeStatus: 'closed'})
          else if value.indexOf('root.trade#') == 0
            ref = value.replace('root.trade#', '')
            $state.go('root.trade', {ref: ref})
          else
            stateParamsString = value.match(/\(.*\)/)
            if stateParamsString
              # example of value: 'root.dashboard.escrow.trades({"tradeStatus": "active"})'
              stateParams = JSON.parse(stateParamsString[0].replace("(", "").replace(")", ""))
              $state.go(value.replace(stateParamsString[0], ""), stateParams)
            else
              $state.go(value)

        else if action == 'SET_DEVICE_IDENTIFIER'
          $window.MOBILE_IDENTIFIER = value
        else if action == 'RELOAD'
          $state.reload()
        else if action == 'TOUCH_ID_TOKEN'
          $rootScope.$broadcast("touch_id_token_received", value)
        else if action == 'TOUCH_ID_CONFIRMED_WITHOUT_TOKEN'
          $rootScope.$broadcast("touch_id_confirmed_without_token", value)
        else if action == 'TOUCH_ID_AVAILABILITY'
          $rootScope.$broadcast("touch_id_availability", value)
        else if action == 'UPLOAD_IMAGE_DONE'
          [handlerIdWithColumn, handlerId] = value.match(/(^.*?):/)
          result = value.replace(handlerIdWithColumn, "")
          $rootScope.$broadcast("mobile_upload_image_done", handlerId, result)
        else
          console.log("Invalid action: " + action + " " + value)

      self = @
      id = setInterval ->
        if $window.webBridgeReady
          clearInterval(id)
          $rootScope.$broadcast("web_bridge_ready")
          self.sendJstorage()
          setTimeout ( ->
            self.sendLocaleData()
          ), 0
      , 1000

    initPullToRefresh: ->
      self = @
      PullToRefresh.init({
        mainElement: 'body',
        onRefresh: ->
          self.reloadCurrentPage()
      })

    initListeners: ->
      if this.exists()
        this.initWebViewBridge()
        this.initPullToRefresh()
    shouldDownloadIos: ->
      $stateParams.country == 'cn' && RAILS_ENV.ios_download_url

    shouldDownloadAndroid: ->
      $stateParams.country == 'cn' && RAILS_ENV.android_download_url

    askForAppReview: ->
      self = @
      if self.ios() && !$.jStorage.get('ios_review_at')
        url = "https://itunes.apple.com/app/id1116327021&mt=8?action=write-review"
      else if self.android() && !$.jStorage.get('android_review_at')
        url = "https://play.google.com/store/apps/details?id=com.remitano.remitano&reviewId=0"
      else
        return
      title = $translate.instant("DIALOGS_NOTIFICATION")
      body = $translate.instant("review_invitation_mobile_app")
      dialogs.confirm(title, body).result.then ->
        if self.ios()
          $.jStorage.set('ios_review_at', new Date())
        else if self.android()
          $.jStorage.set('android_review_at', new Date())
        self.openExternalLink(url)
