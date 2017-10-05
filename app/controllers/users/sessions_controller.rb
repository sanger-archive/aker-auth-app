class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

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
    set_jwt_cookie({"email": params[:user][:email]})
  end

  # DELETE /resource/sign_out
  def destroy
    super
    cookies.delete :aker_user
  end

  def default
  end

  private

  def set_jwt_cookie(auth_hash)
    secret_key = Rails.application.config.jwt_secret_key
    iat = Time.now.to_i
    exp = Time.now.to_i + Rails.application.config.jwt_exp_time
    nbf = Time.now.to_i - Rails.application.config.jwt_nbf_time
    payload = { data: auth_hash, exp: exp, nbf: nbf, iat: iat }
    cookies[:aker_user] = JWT.encode payload, Rails.application.config.jwt_secret_key, 'HS256'
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:redirect_to])
  end
end
