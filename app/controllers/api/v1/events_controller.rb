class Api::V1::EventsController < ApplicationController

  def generate_event
    params['events'].each do |event|
      Event.create(
        url: event['url'],
        visitor_id: event['visitorId'],
        timestamp: event['timestamp']
      )
    end

    response = []
    uniq_visitor_ids = Event.pluck(:visitor_id).uniq

    uniq_visitor_ids.each do |visitor_id|
      visitor_id = {"#{visitor_id}": get_value(visitor_id)}
      response << {'sessionsByUser': visitor_id}
    end

    render json: response
  end

  def get_value(visitor_id)
    visitor_array = []

    visitor_hash = {
      duration: (get_timestamp(visitor_id).max) - (get_timestamp(visitor_id).min),
      pages: Event.where(visitor_id: visitor_id).pluck(:url),
      startTime: get_timestamp(visitor_id).min
    }

    visitor_array << visitor_hash
    return visitor_array
  end

  def get_timestamp(visitor_id)
    time = Event.where(visitor_id: visitor_id).pluck(:timestamp)
  end
end

