class ListHandler
  class << self
    def import(list_id)
      sleep 5

      list = List.find(list_id)

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

        list.increment! :emails_count

        publish data, redis
      end

      list.remove_file!
      list.update_attribute :status, 'Importação Concluída'
    end

    def validate(list_id)
      list = List.find(list_id)

      list_name = "#{list.id}_#{list.name}"
      first_id  = list.list_items.first.id
      last_id   = list.list_items.last.id

      for list_item_id in first_id..last_id do
        EmailValidateJob.perform_later(list_item_id, list_name)
      end
    end

    def email_validate(list_item_id, list_name)
      lists_path = "#{Rails.root}/public/lists/"
      email      = ListItem.find(list_item_id).email

      begin
        if EmailVerifier.check(email.address)
          email.update_attribute(:verification_result, 'Ok')
          File.open(lists_path + "validos_#{list_name}", "a") { |f| f.puts "#{email.address}\r\n"}
        else
          email.update_attribute(:verification_result, 'Bad')
          File.open(lists_path + "invalidos_#{list_name}", "a") { |f| f.puts "#{email.address}\r\n"}
        end
      rescue Exception
        File.open(lists_path + "desconhecidos_#{list_name}", "a") { |f| f.puts "#{email.address}\r\n"}
        raise
      end
    end

    private

    def persist(email, list_id, ar)
      ar.execute %Q(
        INSERT INTO emails (address, created_at, updated_at)
        VALUES ('#{email}', '#{Time.now}', '#{Time.now}')
      )
    rescue Exception; ensure
      email_id = Email.select(:id).where(address: email).first.id

      ar.execute %Q(
        INSERT INTO list_items (list_id, email_id, created_at, updated_at)
        VALUES ('#{list_id}', '#{email_id}', '#{Time.now}', '#{Time.now}')
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
