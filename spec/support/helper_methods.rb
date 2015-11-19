module HelperMethods
  def login!
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @current_user = create(:user)
      sign_in @current_user
    end
  end

  def clean_lists!
    after do
      files = File.join(ListHandler::LISTS_PATH, '*')
      FileUtils.rm(Dir.glob(files))
    end
  end
end
