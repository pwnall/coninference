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
      element.innerHTML = 'Busy'
    else
      element.setAttribute 'class', 'free'
      element.innerHTML = 'Free'

window.Coninference ||= {}
window.Coninference.Rooms = new RoomsClass
$ ->
  if window.coninferenceRoomUrl
    Coninference.Rooms.onChange()
