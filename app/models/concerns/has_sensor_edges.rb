module HasSensorEdges
  # Time-series of a sensor's values during an event's course.
  def sensor_readings_for(event, kind)
    sensor_readings_between event.started_at, event.ended_at || Time.current,
                            kind
  end

  # Time-series of a sensor's values between certain times.
  def sensor_readings_between(start_time, end_time, kind)
    start_time.change usec: 0
    end_time.change usec: 0

    time_series = []
    value = sensor_at start_time, kind

    edges = edges_between(start_time, end_time).where(kind: kind).all
    time = start_time
    offset = 0
    while time < end_time
      while edges[offset] && edges[offset].created_at <= time
        edge = edges[offset]
        value = edge.value
        offset += 1
      end
      time_series.push ts: time.to_i, value: value
      time += 1.second
    end
    time_series
  end

  # All the sensor changes that occured during an event's course.
  def edges_for(event, kind = nil)
    rel = edges_between(event.started_at, event.ended_at)
    if kind
      rel = rel.where(kind: kind)
    end
    rel
  end

  # All the sensor changes that occured between certain times.
  def edges_between(start_time, end_time)
    sensor_edges.after(start_time).before(end_time).order(:created_at)
  end

  # The most recent reported values for all sensors.
  def sensors_at(time)
    values = {}
    SensorEdge::KINDS.each do |kind|
      values[kind] = sensor_at time, kind
    end
    values
  end

  # The most recent reported value for the given sensor.
  def sensor_at(time, kind)
    edge = sensor_edges.where(kind: kind).before(time).order(:created_at).last
    edge && edge.value
  end
end
