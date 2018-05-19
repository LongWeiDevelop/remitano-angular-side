'use strict'

angular.module 'remitano'
.controller 'PartnersController',
($scope, $timeout, $translate, Translate, ContactMessage, isoCountries) ->
  Translate($scope)

  vm = @
  vm.submitting = false
  vm.contact_message = {}

  init = ->
    vm.placeholderText = $scope.placeholderText
    vm.submit = submit
    vm.countries = isoCountries
    return

  toggleForm = ->
    event = document.createEvent('HTMLEvents')
    event.initEvent 'click', true, false
    document.querySelector("#btn_show_form").dispatchEvent(event)

  submit = (form, event)->
    event.preventDefault()
    # Trigger validation
    angular.forEach form, (obj) ->
      if angular.isObject(obj) and angular.isDefined(obj.$setDirty)
        obj.$setDirty()
    return false if form.$invalid
    return if vm.submitting

    vm.submitting = true
    ContactMessage.save(contact_message: vm.contact_message, (data) ->
      vm.submitting = false
      vm.successMessage = "Thanks for your message. We will contact you shortly for further discussion."
      $timeout (-> vm.contact_message = {}), 1000
      toggleForm()
    , (response) ->
      vm.submitting = false
      vm.errorMessage = response.data.error || "Internal server error"
      $timeout ->
        vm.errorMessage = null
      , 4000
    )
    return

  init()
  return
