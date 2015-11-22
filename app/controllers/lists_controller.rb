class ListsController < ApplicationController
  include ActionController::Live

  def upload
    ListImport.create(file: params[:list])
    head :ok
  end

  def import_progress
    sse = SSE.new(response.stream)

    response.headers['Content-Type'] = 'text/event-stream'

    Redis.new.subscribe('list:import-progress') do |on|
      on.message { |e, data| sse.write(JSON.dump(data)) }
    end
  ensure
    sse.close
  end
end
