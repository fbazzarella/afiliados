class Email < ActiveRecord::Base
  validates :address, presence: true, uniqueness: true, format: {with: /\A([a-zA-Z0-9._%+-]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
end
