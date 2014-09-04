require 'rails_helper'

RSpec.describe Devise::SessionsController, type: :controller do
  render_views
  
  login!

  before { delete :destroy }

  it { is_expected.to redirect_to(new_user_session_path) }
end
