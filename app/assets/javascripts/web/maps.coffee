class MapsClass
  constructor: ->
    null

  onChange: ->
    mapUrl = window.coninferenceMapUrl
    fetch(mapUrl)
      .then (response) =>
        response.json()
      .then (json) =>
        @_updateRooms json.rooms

  _updateRooms: (rooms) ->
    for room in rooms
      console.log room
      element = document.querySelector '#' + room.dom_selector
      if room.occupied
        element.setAttribute 'class', 'busy'
      else
        element.setAttribute 'class', 'free'


window.Coninference ||= {}
window.Coninference.Maps = new MapsClass
$ ->
  Coninference.Maps.onChange()
