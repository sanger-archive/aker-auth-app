require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#groups' do
    let(:user) { build(:user) }
    it 'fetches the groups' do
      expect(user.groups).to eq ['pirates', 'world']
    end
  end

  describe '#email' do
    it 'has a sanitised email address' do
      expect(create(:user, email: '   ME@HERE  ').email).to eq('me@here')
    end

    it 'is not valid without a unique sanitised email address' do
      create(:user, email: 'alpha@beta')
      expect(build(:user, email: '   ALPHA@BETA   ')).not_to be_valid
    end

    it 'is valid with a unique sanitised email address' do
      create(:user, email: 'alpha@beta')
      expect(build(:user, email: '   GAMMA@DELTA   ')).to be_valid
    end
  end
end
