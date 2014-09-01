require 'rails_helper'

RSpec.describe ImportError, type: :model do
  it { should validate_presence_of(:file_name) }
  it { should validate_presence_of(:line_number) }
  it { should validate_presence_of(:line_string) }
  it { should validate_presence_of(:error_messages) }

  it { should validate_numericality_of(:line_number) }
end
