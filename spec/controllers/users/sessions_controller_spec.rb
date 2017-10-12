require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  let(:user) { create(:user) }

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

  describe '#destroy' do
    before do
      sign_in user
      cookies[:aker_user_jwt] = 'something that is not nil'
      allow(controller).to receive(:cookies).and_return(cookies)
      allow(session).to receive(:destroy)
      delete :destroy
    end

    it 'should destroy the session' do
      expect(session).to have_received(:destroy).at_least(:once)
    end

    it 'should delete the cookie' do
      expect(cookies[:aker_user_jwt]).to be_nil
    end
  end

  def decode(jwt)
    JWT.decode jwt, Rails.application.config.jwt_secret_key, true, algorithm: 'HS256'
  end

  describe '#renew_jwt' do
    before do
      allow(controller).to receive(:cookies).and_return(cookies)
    end
    context 'when there is session containing an email address' do
      before do
        sign_in user
        session[:email] = user.email
        post :renew_jwt
      end

      def verify_jwt(coded_jwt)
        payload, header = decode(coded_jwt)
        data = payload['data']
        expect(data).to eq({"email"=>user.email, "groups"=>["pirates", "world"]})
        now = Time.now.to_i
        exp = payload['exp']
        nbf = payload['nbf']
        iat = payload['iat']
        expect(exp).to be > now
        expect(nbf).to be < now
        expect(iat).to be_within(1).of(now)
        expect(exp).to eq(iat+Rails.application.config.jwt_exp_time)
        expect(nbf).to eq(iat-Rails.application.config.jwt_nbf_time)
        expect(header['alg']).to eq('HS256')
      end

      it { expect(response).to have_http_status(:ok) }

      it 'supplies a jwt cookie' do
        expect(cookies[:aker_user_jwt]).to be_present
        verify_jwt(cookies[:aker_user_jwt])
      end
      it 'returns the jwt in the body' do
        expect(response.body).to be_present
        verify_jwt(response.body)
      end
    end

    context 'when session does not include an email address' do
      before do
        allow(session).to receive(:destroy)
      end
      before do
        sign_in user
        session[:email] = nil
        post :renew_jwt
      end
      
      it 'destroys the session' do
        expect(session).to have_received(:destroy).at_least(:once)
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
