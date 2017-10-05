class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:renew_jwt]

  @@secret_key = Rails.application.config.jwt_secret_key

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    if params.dig(:user, :email).present? && (params[:user][:email].exclude? "@")
      params[:user][:email] << "@sanger.ac.uk"
    end
    super
    set_session_cookie
    jwt = prepare_jwt_cookie({"email": params[:user][:email], "groups": current_user.groups})
    cookies[:aker_user] = JWT.encode jwt, @@secret_key, 'HS256'
  end

  # DELETE /resource/sign_out
  def destroy
    super
    cookies.delete :aker_user
    cookies.delete :aker_auth_session
  end

  def renew_jwt
    # TODO: Check session is valid
    # Renew JWT if so
    # TODO: (and update expiry date on refresh token)
    # Otherwise, unauthorized error
    user_data = JSON.parse(request.body.read)

    unless user_data.empty?
      jwt = prepare_jwt_cookie({email: user_data["email"], groups: user_data["groups"]})
      response = JWT.encode jwt, @@secret_key, 'HS256'
      render json: response
    else
      render body: "JWT from cookie has expired", status: :unauthorized
    end
  end

  def default
  end

  private

  def prepare_jwt_cookie(auth_hash)
    iat = Time.now.to_i
    exp = Time.now.to_i + Rails.application.config.jwt_exp_time
    nbf = Time.now.to_i - Rails.application.config.jwt_nbf_time
    payload = { data: auth_hash, exp: exp, nbf: nbf, iat: iat }
  end

  def set_session_cookie
    # TODO: Encrypt this once its use is known
    cookies[:aker_auth_session] = {
      expires: 1.month.from_now,
      value: JSON.generate({email: current_user.email, groups: current_user.groups})
    }
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:redirect_to])
  end
end
