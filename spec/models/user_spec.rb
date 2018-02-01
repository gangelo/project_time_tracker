require 'rails_helper'

RSpec.describe User, type: :model do
  context "factories" do
    describe "#user" do
      subject { FactoryBot.build(:user) }
      it { should be_valid }
    end
  end

  context "validations" do
    describe "#email" do
      it { should validate_length_of(:email).is_at_least(3).with_message("must be between 3 and 254 characters") }
      it { should validate_length_of(:email).is_at_most(254).with_message("must be between 3 and 254 characters") }
      it { should_not allow_value("something.at.somewhere.com").for(:email) }
      it { should allow_value("something@somewhere.com").for(:email) }

      it "should be unique, case-insensitive" do
        User.create(email: "user_1@gmail.com", password: "password")
        non_unique_user = User.create(email: "user_1@gmail.com", password: "password")
        expect(non_unique_user).not_to be_valid
      end
    end
  end
end
