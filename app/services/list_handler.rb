class ListHandler
  LISTS_PATH = File.join(Rails.root, '/tmp/lists/')

  class << self
    def save_to_disk(file, uuid)
      persist_lists_path!

      file_path = File.join(LISTS_PATH, uuid)

      File.open(file_path, 'wb') do |f|
        f.write(filter_list(file))
        file_path
      end
    end

    def import_to_database(list_import)
      ar    = ActiveRecord::Base.connection
      redis = Redis.new

      publish_data = {imported_lines: -1}

      File.open(list_import.file_path).each_line do |line|
        publish_data[:imported_lines] += 1

        if publish_data[:imported_lines].zero?
          publish_data.merge! lines_count: line.to_i
          next
        end

        begin
          ar.execute %Q(
            INSERT INTO emails (address, created_at, updated_at)
            VALUES ('#{line.strip}', '#{Time.zone.now}', '#{Time.zone.now}')
          )
        rescue Exception => msg
          Rails.logger.warn "Exception: #{msg}"
        end

        if should_publish?(publish_data)
          new_data = {
            emails_count: Email.count,
            finished:     import_finished?(publish_data)
          }

          redis.publish 'list:import-progress', publish_data.merge!(new_data).to_json
        end
      end

      list_import.destroy
    end

    private

    def persist_lists_path!
      FileUtils.mkdir_p(LISTS_PATH) if not File.exist?(LISTS_PATH)
    end

    def filter_list(file)
      if file.present?
        filter_pattern = /([a-zA-Z0-9._%+-]+@(?:[-a-z0-9]+\.)+[a-z]{2,})/

        file.read.scan(filter_pattern).flatten.tap do |file|
          file.unshift("#{file.size}")
        end.join("\n")
      end
    end

    def should_publish?(publish_data)
      publish_data[:imported_lines] % 1000 == 0 || import_finished?(publish_data)
    end

    def import_finished?(publish_data)
      publish_data[:imported_lines] == publish_data[:lines_count]
    end
  end
end
