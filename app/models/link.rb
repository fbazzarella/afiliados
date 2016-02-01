class Link < ActiveRecord::Base
  belongs_to :shot

  validates :url, presence: true
end
