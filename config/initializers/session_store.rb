AkerAuthService::Application.config.session_store :active_record_store,
   :key => "aker_auth_#{Rails.env}",
   :expire_after => 1.month
