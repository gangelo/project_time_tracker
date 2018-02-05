require 'rails_helper'

#RSpec.describe HttpError, type: :model do
describe "HttpError" do
  before do
    @http_error = HttpError.new(:internal_server_error, 500,
                           :internal_server_error.to_s.titleize,
                           '/root/home')
  end

  context "variables" do
    describe "@http_error" do
      it "should not be nil" do
        expect(@http_error).not_to eq(nil)
      end
    end
  end

  context "public attributes" do
    describe "#http_status_symbol" do
      it "should equal :internal_server_error" do
        expect(@http_error.http_status_symbol).to eq(:internal_server_error)
      end
    end

    describe "#http_status" do
      it "should equal 500" do
        expect(@http_error.http_status).to eq(500)
      end
    end

    describe "#http_status_message" do
      it "should equal Internal Server Error" do
        expect(@http_error.http_status_message).to eq("Internal Server Error")
      end
    end

    describe "#redirect_to" do
      it "should equal /root/home" do
        expect(@http_error.redirect_to).to eq("/root/home")
      end
    end
  end
end
