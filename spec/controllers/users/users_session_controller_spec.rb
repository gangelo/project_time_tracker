require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  before (:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryBot.create(:user_with_user_role)
  end

  describe "log in" do

    context "POST create" do
      it "logs in an existing user and redirects to the root path" do
        post :create, params: { user: { email: @user.email, password: @user.password } }
        expect(request.flash[:notice]).to start_with("Signed in successfully")
        expect(response).to redirect_to(root_path)
      end

      it "prohibits an invalid account from logging in" do
        post :create, params: { user: { email: 'bad@email.com', password: 'bad-password' } }
        expect(request.flash[:alert]).to start_with("Invalid")
      end
    end
  end

   describe "log out" do

    context "GET destroy" do
      it "prohibits an invalid account from logging in" do
        get :destroy
        expect(request.flash[:notice]).to start_with("Signed out")
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
