class PushNotificationsClass
  constructor: ->
    @_registration = null
    @_storage = window.sessionStorage or window.localStorage

  # Called when the window loads.
  onload: ->
    return unless W3gram.pushRegistrationManager
    W3gram.pushRegistrationManager.register()
      .then (registration) =>
        @_registration = registration
        registration.onpush = @_onpush.bind @
        @_updateServer()
      .catch (error) ->
        console.error error

  # Called when a push notification is received.
  _onpush: (event) ->
    message = JSON.parse event.data
    switch message.cmd
      when 'reload'
        if typeof window.location.reload is 'function'
          window.location.reload()
        # This only gets executed if the previous line failed.
        window.location = window.location.href
      when 'device-liability'
        SmartCup.Liabilities.onUpdate message

  # Uploads the push notification to the server, if it changed.
  _updateServer: ->
    receiverId = @_registration.registrationId
    pushUrl = @_registration.endpoint
    @loadRegistration()
      .then (oldRegistration) =>
        if receiverId is oldRegistration.receiverId and
            pushUrl is oldRegistration.pushUrl
          return
        @uploadRegistration()

  # @return {Promise<Object>} loads old registration data from localStorage
  loadRegistration: ->
    new Promise (resolve, reject) =>
      receiverId = @_storage.getItem 'reborn-tab-push-receiver'
      pushUrl = @_storage.getItem 'reborn-tab-push-url'
      resolve receiverId: receiverId, pushUrl: pushUrl

  # @return {Promise<Boolean>} saves registration data to localStorage
  saveRegistration: ->
    new Promise (resolve, reject) =>
      @_storage.setItem 'reborn-tab-push-receiver',
                        @_registration.registrationId
      @_storage.setItem 'reborn-tab-push-url',
                        @_registration.endpoint
      resolve true

  # Sends the current registration to the server.
  uploadRegistration: ->
    data =
        push_url: @_registration.endpoint
    $.ajax(type: 'POST', url: '/session/push_info', data: data)
      .done => @saveRegistration()


window.SmartCup ||= {}
window.SmartCup.PushNotifications = new PushNotificationsClass
$ ->
  SmartCup.PushNotifications.onload()

