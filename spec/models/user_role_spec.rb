require 'rails_helper'

RSpec.describe UserRole, type: :model do
  context "factories" do
    describe "#user_role" do
      subject { FactoryBot.build(:user_role) }
      it { should be_valid }
    end
  end

  context "model associations" do
    it { should belong_to(:user) }
    it { should belong_to(:role) }
  end
end
