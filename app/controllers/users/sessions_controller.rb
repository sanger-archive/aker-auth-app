class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:renew_jwt]

  # POST /resource/sign_in
  def create
    if params.dig(:user, :email).present? && (params[:user][:email].exclude? "@")
      params[:user][:email] << "@sanger.ac.uk"
    end

    super

    session[:email] = current_user.email

    cookies[:aker_user_jwt] = make_jwt(email: params[:user][:email], groups: current_user.groups)
  end

  # DELETE /resource/sign_out
  def destroy
    super
    cookies.delete :aker_user_jwt
    session.destroy
  end

  def renew_jwt
    # Check session is valid
    # Renew JWT if so
    # Otherwise, unauthorized error

    if session[:email].present?
      jwt = make_jwt(email: session[:email], groups: User.find_by(email: session[:email]).groups)
      cookies[:aker_user_jwt] = jwt
      render body: jwt, status: :ok
    else
      # User has been banned (or wasn't signed in to auth service depending on what state this code is in)
      destroy
    end
  end

  def default
  end

private

  def make_jwt(data)
    iat = Time.now.to_i
    exp = iat + Rails.application.config.jwt_exp_time
    nbf = iat - Rails.application.config.jwt_nbf_time
    payload = { data: data, exp: exp, nbf: nbf, iat: iat }
    JWT.encode payload, Rails.application.config.jwt_secret_key, 'HS256'
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:redirect_to])
  end
end
