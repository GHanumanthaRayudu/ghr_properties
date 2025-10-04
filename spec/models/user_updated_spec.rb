require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:properties).dependent(:destroy) }
    it { should have_many(:inquiries).with_foreign_key('customer_id').dependent(:destroy) }
    it { should have_many(:sent_messages).class_name('Message').with_foreign_key('sender_id').dependent(:destroy) }
    it { should have_many(:received_messages).class_name('Message').with_foreign_key('receiver_id').dependent(:destroy) }
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:favorite_properties).through(:favorites).source(:property) }
  end

  describe 'validations' do
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:email) }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(developer: 0, agent: 1, customer: 2) }
  end

  describe 'scopes' do
    let!(:developer) { create(:user, role: :developer) }
    let!(:agent) { create(:user, role: :agent) }
    let!(:customer) { create(:user, role: :customer) }

    it 'returns only developers' do
      expect(User.developers).to contain_exactly(developer)
    end

    it 'returns only agents' do
      expect(User.agents).to contain_exactly(agent)
    end

    it 'returns only customers' do
      expect(User.customers).to contain_exactly(customer)
    end

    it 'returns developers and agents who can post properties' do
      expect(User.can_post_properties).to contain_exactly(developer, agent)
    end
  end

  describe '#can_post_property?' do
    it 'returns true for developers' do
      developer = build(:user, role: :developer)
      expect(developer.can_post_property?).to be true
    end

    it 'returns true for agents' do
      agent = build(:user, role: :agent)
      expect(agent.can_post_property?).to be true
    end

    it 'returns false for customers' do
      customer = build(:user, role: :customer)
      expect(customer.can_post_property?).to be false
    end
  end

  describe '#can_manage_inquiries?' do
    it 'returns true for developers' do
      developer = build(:user, role: :developer)
      expect(developer.can_manage_inquiries?).to be true
    end

    it 'returns true for agents' do
      agent = build(:user, role: :agent)
      expect(agent.can_manage_inquiries?).to be true
    end

    it 'returns false for customers' do
      customer = build(:user, role: :customer)
      expect(customer.can_manage_inquiries?).to be false
    end
  end

  describe '#name' do
    it 'returns titleized email prefix' do
      user = build(:user, email: 'john.doe@example.com')
      expect(user.name).to eq('John.Doe')
    end
  end
end


