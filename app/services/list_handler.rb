class ListHandler
  LISTS_PATH = File.join(Rails.root, '/tmp/lists/')

  class << self
    def save_to_disk(file)
      persist_lists_path!

      created_at = Time.zone.now.strftime('%Y%m%d%H%M%S')
      file_path  = File.join(LISTS_PATH, created_at)

      File.open(file_path, 'wb') do |f|
        f.write(filter_list(file))
        file_path
      end
    end

    def import_to_database(list_import)
      ar    = ActiveRecord::Base.connection
      file  = File.open(list_import.file_path).to_a
      redis = Redis.new

      publish_params = {
        total_lines: file.size
      }

      file.each_with_index do |line, i|
        now = Time.zone.now
        sql = %Q(
          INSERT INTO emails
            (address, created_at, updated_at)
          VALUES
            ('#{line.strip}', '#{now}', '#{now}')
        )

        begin
          redis.publish('list:import-progress', publish_params.merge!(imported_lines: i + 1).to_json)
          ar.execute(sql)
        rescue Exception => msg
          Rails.logger.warn "Exception: #{msg}"
        end
      end

      list_import.destroy
    end

    private

    def persist_lists_path!
      FileUtils.mkdir_p(LISTS_PATH) if not File.exist?(LISTS_PATH)
    end

    def filter_list(file)
      email_pattern = /([a-zA-Z0-9._%+-]+@(?:[-a-z0-9]+\.)+[a-z]{2,})/
      file.read.scan(email_pattern).flatten.join("\n") if file.present?
    end
  end
end
