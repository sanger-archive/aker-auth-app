require 'rails_helper'

RSpec.describe Session, type: :model do
  describe '#sweep' do
    let!(:old_session) { Session.create(session_id: SecureRandom.uuid, created_at: 10.days.ago) }
    let!(:recent_session) { Session.create(session_id: SecureRandom.uuid, created_at: 1.days.ago) }

    it 'deletes old sessions' do
      expect(Session.all.count).to eq(2)
      Session.sweep
      expect(Session.all.count).to eq(1)
      expect(Session.first.session_id).to eq(recent_session.session_id)
    end

  end
end
