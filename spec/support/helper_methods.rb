module HelperMethods
  def login!
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @current_user = create(:user)
      sign_in @current_user
    end
  end
end
