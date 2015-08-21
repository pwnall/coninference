class RoomsClass
  constructor: ->
    null

  onChange: ->
    roomUrl = window.coninferenceRoomUrl
    fetch(roomUrl)
      .then (response) =>
        response.json()
      .then (json) =>
        @_updateOccupancyIndicator json.occupied

  _updateOccupancyIndicator: (occupied) ->
    console.log occupied
    element = document.querySelector '#occupancy-indicator'
    if occupied
      element.setAttribute 'class', 'busy'
    else
      element.setAttribute 'class', 'free'

window.Coninference ||= {}
window.Coninference.Rooms = new RoomsClass
$ ->
  if window.coninferenceRoomUrl
    Coninference.Rooms.onChange()
