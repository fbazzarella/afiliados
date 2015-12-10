CarrierWave.configure do |config|
  config.root = Rails.root
end

if Rails.env.test?
  ListUploader

  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?

    klass.class_eval do
      def store_dir
        "tmp/lists/test"
      end

      def cache_dir
        "tmp/lists/test/cache"
      end
    end
  end
end
