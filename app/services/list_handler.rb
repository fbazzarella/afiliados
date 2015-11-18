class ListHandler
  # Benchmarking Import Process with 1 Thread

  # Rails ActiveRecord  09:21:52 - 10:05:03 ~43m11
  # Pure SQL            10:49:16 - 10:55:51 ~06m35

  # Total Lines:   323658
  # Unique Lines:   20145
  # Duplicated:    303513

  LISTS_PATH = File.join(Rails.root, '/tmp/lists/')

  def initialize(file)
    @file = file
  end

  def save_to_disk_and_import!
    persist_lists_path!

    file_path = File.join(LISTS_PATH, Time.now.strftime('%Y%m%d%H%M%S'))

    File.open(file_path, 'wb') { |file| file.write(filter_list(@file)) }

    @file = File.open(file_path, 'r')

    import_to_database!
  end

  private

  def import_to_database!
    ar = ActiveRecord::Base.connection

    @file.each_line do |line|
      now = Time.zone.now

      sql = %Q(
        INSERT INTO emails
          (address, created_at, updated_at)
        VALUES
          ('#{line.strip}', '#{now}', '#{now}')
      )

      begin
        ar.execute(sql)
      rescue Exception => msg
        Rails.logger.warn "== Exception: #{Time.zone.now.strftime("%FT%R")} - #{msg}"
      end
    end

    remove_from_disk!
  end

  def persist_lists_path!
    FileUtils.mkdir_p(LISTS_PATH) if not File.exist?(LISTS_PATH)
  end

  def remove_from_disk!
    FileUtils.rm(@file)
    @file = nil
  end

  def filter_list(file)
    email_pattern = /([a-zA-Z0-9._%+-]+@(?:[-a-z0-9]+\.)+[a-z]{2,})/
    file.read.scan(email_pattern).flatten.join("\n")
  end
end
