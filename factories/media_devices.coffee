'use strict'

angular.module 'remitano'
.factory "MediaDevices", ($q) ->
  if navigator.mediaDevices and navigator.mediaDevices.enumerateDevices
    # Firefox 38+ seems having support of enumerateDevicesx
    navigator.enumerateDevices = (callback) ->
      navigator.mediaDevices.enumerateDevices().then callback
      return

  MediaDevices = []
  isHTTPs = location.protocol == 'https:'
  canEnumerate = false
  if typeof MediaStreamTrack != 'undefined' and 'getSources' of MediaStreamTrack
    canEnumerate = true
  else if navigator.mediaDevices and ! !navigator.mediaDevices.enumerateDevices
    canEnumerate = true
  hasMicrophone = false
  hasSpeakers = false
  hasWebcam = false
  isMicrophoneAlreadyCaptured = false
  isWebcamAlreadyCaptured = false

  factory =
    checkDeviceSupport: (callback) ->
      defer = $q.defer()
      if !canEnumerate
        return
      if !navigator.enumerateDevices and window.MediaStreamTrack and window.MediaStreamTrack.getSources
        navigator.enumerateDevices = window.MediaStreamTrack.getSources.bind(window.MediaStreamTrack)
      if !navigator.enumerateDevices and navigator.enumerateDevices
        navigator.enumerateDevices = navigator.enumerateDevices.bind(navigator)
      if !navigator.enumerateDevices
        if callback
          callback()
        return
      MediaDevices = []
      navigator.enumerateDevices (devices) ->
        devices.forEach (_device) ->
          device = {}
          for d of _device
            device[d] = _device[d]
          if device.kind == 'audio'
            device.kind = 'audioinput'
          if device.kind == 'video'
            device.kind = 'videoinput'
          skip = undefined
          MediaDevices.forEach (d) ->
            if d.id == device.id and d.kind == device.kind
              skip = true
            return
          if skip
            return
          if !device.deviceId
            device.deviceId = device.id
          if !device.id
            device.id = device.deviceId
          if !device.label
            device.label = 'Please invoke getUserMedia once.'
            if !isHTTPs
              device.label = 'HTTPs is required to get label of this ' + device.kind + ' device.'
          else
            if device.kind == 'videoinput' and !isWebcamAlreadyCaptured
              isWebcamAlreadyCaptured = true
            if device.kind == 'audioinput' and !isMicrophoneAlreadyCaptured
              isMicrophoneAlreadyCaptured = true
          if device.kind == 'audioinput'
            hasMicrophone = true
          if device.kind == 'audiooutput'
            hasSpeakers = true
          if device.kind == 'videoinput'
            hasWebcam = true
          # there is no 'videoouput' in the spec.
          MediaDevices.push device
        callback() if callback
        defer.resolve(
          hasWebcam: hasWebcam
          hasMicrophone: hasMicrophone
          isMicrophoneAlreadyCaptured: isMicrophoneAlreadyCaptured
          isWebcamAlreadyCaptured: isWebcamAlreadyCaptured
        )
      defer.promise

  factory.currentDeviceSupport = null
  if defer = factory.checkDeviceSupport()
    defer.then (result) ->
      factory.currentDeviceSupport = result

  factory
