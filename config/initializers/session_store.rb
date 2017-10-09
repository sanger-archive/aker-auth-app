AkerAuthService::Application.config.session_store :active_record_store,
   :key => 'aker_auth_session',
   :expire_after => 1.month
