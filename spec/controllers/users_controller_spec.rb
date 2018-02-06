require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    # Change the access modifier on all protected members to public so we can
    # test or use them.
    #UserPolicy.send(:public, *UserPolicy.protected_instance_methods)

    #allow_any_instance_of(UserPolicy).to
    #  receive(:default_policy).and_return(true)
  end

  before(:each) do
    @admin_user = admin_user
    sign_in @admin_user
  end

  after(:all) do
    #sign_out @admin_user
  end

  describe "@admin_user" do
    it "should not be nil" do
      expect(@admin_user).not_to be(nil)
    end

    it "should not be valid" do
      expect(@admin_user.valid?).to be(true)
    end
  end

  describe "GET #index" do
    it "should raise an Pundit::NotAuthorizedError error if the user is not authorized" do
      sign_out @admin_user
      expect { get :index }.to raise_error(Pundit::NotAuthorizedError)
      #expect(response).to be_unsuccessful
      #expect(response).to redirect_to(unauthorized_error_path)
    end

    it "should return :success for admin users" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

end
