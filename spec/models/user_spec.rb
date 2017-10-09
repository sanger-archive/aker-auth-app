require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe '#groups' do
    it 'fetches the groups' do
      expect(user.groups).to eq ['pirates', 'world']
    end
  end
end
