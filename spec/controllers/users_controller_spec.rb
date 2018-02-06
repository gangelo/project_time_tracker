require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:each) do
    @admin_user = admin_user
    sign_in @admin_user
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
    it "should raise an Pundit::NotAuthorizedError error if the user is not authorized" do
      sign_out @admin_user
      expect { get :new }.to raise_error(Pundit::NotAuthorizedError)
    end

    it "should return :success for admin users" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "should raise an Pundit::NotAuthorizedError error if the user is not authorized" do
      sign_out @admin_user
      expect { get :edit, params: non_admin_user.attributes }.to raise_error(Pundit::NotAuthorizedError)
    end

    it "should return :success for admin users" do
      get :edit, params: non_admin_user.attributes
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "should raise an Pundit::NotAuthorizedError error if the user is not authorized" do
      sign_out @admin_user
      expect { get :show, params: { id: non_admin_user.id } }.to raise_error(Pundit::NotAuthorizedError)
    end

    it "should return :success for admin users" do
      get :show, params: { id: non_admin_user.id }
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    it "should raise an Pundit::NotAuthorizedError error if the user is not authorized" do
      sign_out @admin_user
      expect { put :update, params: { id: non_admin_user.id, user: {
        user_name: 'user_name' } }
      }.to raise_error(Pundit::NotAuthorizedError)
    end

    it "should return :success for admin users" do
      put :update, params: { id: non_admin_user.id, user: {
        user_name: 'user_name' } }
      expect(response).to redirect_to(users_path)
    end
  end

end
