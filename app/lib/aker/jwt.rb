module Aker
  class Jwt

    def self.from_user(user)
      secret_key = Rails.configuration.x.jwt[:secret_key]

      exp = Time.now.to_i + Rails.configuration.x.jwt[:exp_time]
      nbf = Time.now.to_i - Rails.configuration.x.jwt[:nbf_time]

      data = user.attributes.merge(groups: user.groups)

      payload = { data: data, exp: exp, nbf: nbf }

      JWT.encode payload, secret_key, 'HS256'
    end

  end
end