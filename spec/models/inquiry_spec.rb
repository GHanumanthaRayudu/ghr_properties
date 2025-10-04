require 'rails_helper'

RSpec.describe Inquiry, type: :model do
  describe 'associations' do
    it { should belong_to(:customer).class_name('User') }
    it { should belong_to(:property) }
  end

  describe 'validations' do
    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:customer_id) }
    it { should validate_presence_of(:property_id) }
    it { should validate_length_of(:message).is_at_least(10).is_at_most(1000) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, responded: 1, closed: 2) }
  end

  describe 'scopes' do
    let(:property) { create(:property) }
    let!(:inquiry1) { create(:inquiry, property: property, created_at: 1.day.ago) }
    let!(:inquiry2) { create(:inquiry, property: property, created_at: 2.days.ago) }

    it 'orders by created_at desc with recent scope' do
      expect(Inquiry.recent).to eq([inquiry1, inquiry2])
    end
  end

  describe 'custom validations' do
    let(:developer) { create(:user, role: :developer) }
    let(:customer) { create(:user, role: :customer) }
    let(:property) { create(:property, user: developer) }

    it 'allows inquiry creation for customer role' do
      inquiry = build(:inquiry, customer: customer, property: property)
      expect(inquiry).to be_valid
    end

    it 'prevents inquiry creation for non-customer roles' do
      inquiry = build(:inquiry, customer: developer, property: property)
      expect(inquiry).not_to be_valid
      expect(inquiry.errors[:customer]).to include('must have customer role to create inquiries')
    end
  end
end


