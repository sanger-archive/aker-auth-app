module Aker
  class Proxy < Rack::Proxy

    def perform_request(env)
      request = Rack::Request.new(env)

      Rails.configuration.proxy.each do |path, forward_host|
        test_path(path).match(request.path) do |m|
          uri = URI.parse(forward_host)
          set_env(env, uri, m.captures.first)

          # Super make sure Squid doesn't interfere
          ENV['HTTP_PROXY'] = nil
          ENV['http_proxy'] = nil
          ENV['https_proxy'] = nil

          return super(env)
        end
      end

      # This will only be called if none of the test_paths match
      @app.call(env)
    end

  private

    # If path is "set_service"
    # /set_service will match
    # /set_service/ will match
    # /set_service/plus/any/other/thing/after will match
    def test_path(path)
      /^\/#{path}\/?(.*)$/
    end

    def set_env(env, uri, host_path)
      env["HTTP_HOST"] = uri.host
      env["SERVER_PORT"] = uri.port
      env["PATH_INFO"] = [uri.path, host_path].join("/")
      env["HTTP_CONNECTION"] = "close"

      # env['warden'].user is a User model if there's an authenticated user, nil otherwise
      env["HTTP_X_AUTHORISATION"] = Aker::Jwt.from_user(env['warden'].user) if env['warden'].user
    end

  end
end