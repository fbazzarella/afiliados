require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'menu_link_to' do
    it { expect(menu_link_to('Test')).to match /Test/ }
  end
end
