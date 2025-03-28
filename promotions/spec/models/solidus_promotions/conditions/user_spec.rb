# frozen_string_literal: true

require "rails_helper"

RSpec.describe SolidusPromotions::Conditions::User, type: :model do
  let(:condition) { described_class.new }

  it { is_expected.to have_many(:users) }

  it { is_expected.to be_updateable }

  describe "user_ids=" do
    subject { condition.user_ids = [user.id] }

    let(:promotion) { create(:solidus_promotion, :with_adjustable_benefit) }
    let(:benefit) { promotion.benefits.first }
    let(:user) { create(:user) }
    let(:condition) { described_class.new(users: [user], benefit: benefit) }

    it "creates a valid condition with a user" do
      expect(condition).to be_valid
    end
  end

  describe "#preload_relations" do
    subject { condition.preload_relations }
    it { is_expected.to eq([:users]) }
  end

  describe "#eligible?(order)" do
    let(:order) { Spree::Order.new }

    it "is not eligible if users are not provided" do
      expect(condition).not_to be_eligible(order)
    end

    it "is eligible if users include user placing the order" do
      user = mock_model(Spree::LegacyUser)
      users = [user, mock_model(Spree::LegacyUser)]
      allow(condition).to receive_messages(users: users)
      allow(order).to receive_messages(user: user)

      expect(condition).to be_eligible(order)
    end

    it "is not eligible if user placing the order is not listed" do
      allow(order).to receive_messages(user: mock_model(Spree::LegacyUser))
      users = [mock_model(Spree::LegacyUser), mock_model(Spree::LegacyUser)]
      allow(condition).to receive_messages(users: users)

      expect(condition).not_to be_eligible(order)
    end

    # Regression test for https://github.com/spree/spree/issues/3885
    it "can assign to user_ids" do
      user1 = Spree::LegacyUser.create!(email: "test1@example.com")
      user2 = Spree::LegacyUser.create!(email: "test2@example.com")
      condition.user_ids = "#{user1.id}, #{user2.id}"
    end
  end
end
