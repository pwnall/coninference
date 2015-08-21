class SensorDataGraph
  constructor: (domRoot) ->
    @_domRoot = domRoot
    @_url = domRoot.getAttribute 'data-sensor-url'
    @_context = @_domRoot.getContext '2d'
    @_data = []
    @_built = false
    @_pendingFetch = null
    dataset =
      data: []
      fillColor: "rgba(151,187,205,0.2)",
      strokeColor: "rgba(151,187,205,1)",
      pointColor: "rgba(151,187,205,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "#fff",
      pointHighlightStroke: "rgba(151,187,205,1)",
    @_chart = new Chart(@_context).Line(
        { labels: [], datasets: [dataset] },
        { animation: false })

    @_fetchData().then (data) =>
      @_updateData data
      @_chart.update()

  onChange: ->
    return unless @_pendingFetch is null
    @_fetchData().then (data) =>
      @_updateData data
      @_chart.update()

  _updateData: (newData) ->
    return if newData.length is 0
    oldData = @_data
    ts0 = newData[0].ts
    offset = 0
    while offset < oldData.length && oldData[offset].ts < ts0
      @_chart.removeData()
      offset += 1

    if oldData.length is 0
      tsMax = -1
    else
      tsMax = oldData[oldData.length - 1].ts

    for item in newData
      if item.ts > tsMax
        @_chart.addData [item.value], item.ts
    @_data = newData

  # @return {Promise<Array>} promise resolved with an array of sensor readings
  _fetchData: ->
    if @_pendingFetch isnt null
      return @_pendingFetch

    @_pendingFetch = fetch(@_url)
        .then (response) =>
          response.json()
        .then (jsonData) =>
          @_pendingFetch = null
          jsonData.readings

window.Coninference ||= {}
Coninference.sensorGraps = []
document.addEventListener 'DOMContentLoaded', ->
  Coninference.sensorGraphs =
      for element in document.querySelectorAll('canvas.sensor-data')
        new SensorDataGraph(element)
