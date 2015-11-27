class ListsController < ApplicationController
  include ActionController::Live

  def upload
    ListImport.create(file: params[:list])
    head :ok
  end

  def import_progress
    redis = Redis.new
    sse   = SSE.new(response.stream)

    response.headers['Content-Type'] = 'text/event-stream'

    redis.subscribe('list:import-progress') do |on|
      on.message do |e, data|
        sse.write(data)
        sse.close if JSON.parse(data)['finished']
      end
    end
  rescue IOError
  ensure
    redis.quit
    sse.close
  end
end
