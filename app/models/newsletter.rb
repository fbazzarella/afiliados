class Newsletter < ActiveRecord::Base
  has_many :campaigns, dependent: :restrict_with_error
end
