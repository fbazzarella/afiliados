class ListHandler
  class << self
    def import(list)
      return if not list.file.present?

      ar    = ActiveRecord::Base.connection
      redis = Redis.new

      data = {list_id: list.id, imported_lines: -1}

      filter(list.file).each do |line|
        data[:imported_lines] += 1

        if data[:imported_lines].zero?
          data.merge! lines_count: line
          next
        end

        persist line, data[:list_id], ar

        publish data, redis
      end

      list.remove_file!
      list.update_attribute :import_finished, true
    end

    private

    def persist(email, list_id, ar)
      ar.execute %Q(
        INSERT INTO emails (address, created_at, updated_at)
        VALUES ('#{email}', '#{Time.now}', '#{Time.now}')
      )
    rescue Exception; ensure
      ar.execute %Q(
        INSERT INTO list_items (list_id, email_id, created_at, updated_at)
        VALUES ('#{list_id}', (
          SELECT id FROM emails WHERE address = '#{email}'
        ), '#{Time.now}', '#{Time.now}')
      )
    end

    def filter(file)
      filter_pattern = /([a-zA-Z0-9._%+-]+@(?:[-a-z0-9]+\.)+[a-z]{2,})/

      file.read.scan(filter_pattern).flatten.uniq.tap do |file|
        file.unshift file.size
      end
    end

    def publish(data, redis)
      redis.publish 'list:import-progress', data.to_json if should_publish?(data)
    end

    def should_publish?(data)
      data[:imported_lines] % 1000 == 0 || import_finished?(data)
    end

    def import_finished?(data)
      data[:imported_lines] == data[:lines_count]
    end
  end
end
