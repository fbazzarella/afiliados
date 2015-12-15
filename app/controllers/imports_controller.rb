class ImportsController < ApplicationController
  include ActionController::Live

  def progress
    redis = Redis.new
    sse   = SSE.new(response.stream)

    response.headers['Content-Type'] = 'text/event-stream'

    redis.subscribe('list:import-progress') do |on|
      on.message { |e, data| sse.write(data) }
    end
  rescue IOError; ensure
    redis.quit
    sse.close
  end
end
