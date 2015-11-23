# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Load the custom environment variables.
begin
  File.open(File.expand_path('../../.env', __FILE__), 'r') do |f|
    f.each_line do |line|
      next if line == "\n" || line.match(/^#/) || line.match(/^PATH/)

      line = line.gsub("\n", '').split('=')

      ENV[line.first] = line.last
    end
  end
rescue Errno::ENOENT; end
