require 'rails_helper'

RSpec.describe Property, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:messages).dependent(:destroy) }
    it { should have_many(:transactions).dependent(:destroy) }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:inquiries).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:bedrooms) }
    it { should validate_presence_of(:bathrooms) }
    it { should validate_presence_of(:area) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:status) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should validate_numericality_of(:bedrooms).is_greater_than(0).only_integer }
    it { should validate_numericality_of(:bathrooms).is_greater_than(0).only_integer }
    it { should validate_numericality_of(:area).is_greater_than(0) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(available: 0, sold: 1, ongoing: 2, rented: 3) }
    it { should define_enum_for(:property_type).with_values(house: 0, apartment: 1, condo: 2, land: 3, commercial: 4).with_prefix }
  end

  describe 'custom validations' do
    let(:developer) { create(:user, role: :developer) }
    let(:agent) { create(:user, role: :agent) }
    let(:customer) { create(:user, role: :customer) }

    it 'allows property creation for developers' do
      property = build(:property, user: developer)
      expect(property).to be_valid
    end

    it 'allows property creation for agents' do
      property = build(:property, user: agent)
      expect(property).to be_valid
    end

    it 'prevents property creation for customers' do
      property = build(:property, user: customer)
      expect(property).not_to be_valid
      expect(property.errors[:user]).to include('must be a developer or agent to post properties')
    end
  end

  describe 'scopes' do
    let(:developer) { create(:user, role: :developer) }
    let!(:available_property) { create(:property, status: :available, user: developer) }
    let!(:sold_property) { create(:property, status: :sold, user: developer) }
    let!(:house) { create(:property, property_type: :house, user: developer) }
    let!(:apartment) { create(:property, property_type: :apartment, user: developer) }

    describe '.available_properties' do
      it 'returns only available properties' do
        expect(Property.available_properties).to include(available_property)
        expect(Property.available_properties).not_to include(sold_property)
      end
    end

    describe '.by_property_type' do
      it 'filters by property type' do
        expect(Property.by_property_type(:house)).to include(house)
        expect(Property.by_property_type(:apartment)).to include(apartment)
      end
    end

    describe '.by_status' do
      it 'filters by status' do
        expect(Property.by_status(:available)).to include(available_property)
        expect(Property.by_status(:sold)).to include(sold_property)
      end
    end
  end

  describe '#location' do
    it 'returns city and state' do
      property = build(:property, city: 'Mumbai', state: 'Maharashtra')
      expect(property.location).to eq('Mumbai, Maharashtra')
    end
  end

  describe '#posted_by' do
    it 'returns the user who posted the property' do
      developer = create(:user, role: :developer)
      property = build(:property, user: developer)
      expect(property.posted_by).to eq(developer)
    end
  end
end


