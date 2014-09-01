class ImportError < ActiveRecord::Base
  validates :line_number, :line_string, :error_messages, presence: true
  validates :line_number, numericality: true
end
