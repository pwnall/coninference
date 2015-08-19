class SensorDataGraph
  constructor: (domRoot) ->
    @_domRoot = domRoot
    @_url = domRoot.getAttribute 'data-sensor-url'
    @_context = @_domRoot.getContext '2d'
    @_chart = null
    @_data = null

    @_fetchData().then (data) =>
      console.log data
      @_data = data
      @_buildChart()

  # @return {Promise<Array>} promise resolved with an array of sensor readings
  _fetchData: ->
    fetch(@_url)
        .then (response) ->
          response.json()
        .then (jsonData) ->
          jsonData.readings

  _buildChart: ->
    labels = [0...@_data.length]
    dataset =
      data: @_data
      fillColor: "rgba(151,187,205,0.2)",
      strokeColor: "rgba(151,187,205,1)",
      pointColor: "rgba(151,187,205,1)",
      pointStrokeColor: "#fff",
      pointHighlightFill: "#fff",
      pointHighlightStroke: "rgba(151,187,205,1)",
    @_chart = new Chart(@_context).Line labels: labels, datasets: [dataset]

document.addEventListener 'DOMContentLoaded', ->
  window.Coninference ||= {}
  Coninference.sensorGraphs =
      for element in document.querySelectorAll('canvas.sensor-data')
        new SensorDataGraph(element)
