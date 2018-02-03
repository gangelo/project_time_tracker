require 'rails_helper'

RSpec.describe Role, type: :model do
  context "factories" do
    describe "#role" do
      subject { FactoryBot.build(:role) }
      it { should be_valid }
    end
  end

  context "model associations" do
    describe "users" do
      it { should have_many(:users).through(:user_roles) }
    end
  end

  context "validations" do
    describe "#name" do
      it { should validate_presence_of(:name).with_message(/is required/) }
      it { should allow_value("user").for(:name) }

      it "should validate the uniqueness of case-insensitive" do
        Role.create(name: 'user')
        non_unique_user = Role.create(name: 'USER')
        expect(non_unique_user.errors[:name]).to include(/is already taken/)
      end
    end
  end
end
