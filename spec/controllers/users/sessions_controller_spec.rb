require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe '#create' do
    context 'when the parameters include an email address' do

      let(:email) { 'user@sanger.ac.uk' }
      before do
        post :create, params: { user: { email: email } }
      end

      it 'should set the email in the session' do
        expect(session[:email]).to eq(email)
      end

      it 'should return the jwt cookie' do
        expect(response.headers['Set-Cookie']).to include('aker_user_jwt')
      end

      it { expect(response).to have_http_status :found }
    end

    context 'when the parameters include a username' do
      let(:username) { 'user' }
      before do
        post :create, params: { user: { email: username } }
      end

      it 'should set the full email in the session' do
        expect(session[:email]).to eq(username+ '@sanger.ac.uk')
      end
    end
  end

  # describe '#destroy' do
  #   let(:sesh) do
  #     s = Session.create(session_id: SecureRandom.uuid)
  #     allow(s).to receive(:destroy)
  #     s
  #   end
  #   before do
  #     post :destroy, session: [sesh]
  #   end

  #   it 'should destroy the session' do

  #   end

  #   it 'should delete the cookie' do
  #     debugger
  #   end
  # end
end
