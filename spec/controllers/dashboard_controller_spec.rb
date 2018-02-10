require 'rails_helper'

RSpec.describe DashboardController, type: :controller do

  describe "GET #start_task" do
    it "returns http success" do
      get :start_task
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #stop_task" do
    it "returns http success" do
      get :stop_task
      expect(response).to have_http_status(:success)
    end
  end

end
