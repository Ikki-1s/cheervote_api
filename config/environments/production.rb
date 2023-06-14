require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Include generic and useful information about system operation, but avoid logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII).
  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment).
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "app_production"

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  config.action_mailer.raise_delivery_errors = true

  # メール認証設定
  # mailメソッドオプション (:from、:reply_toなど)のデフォルト値を設定
  config.action_mailer.default_options = { from: ENV['FROM_EMAIL_ADDRESS'] }
  # アプリケーションのホスト情報をメーラー内で使いたい場合は:hostパラメータを明示的に指定
  config.action_mailer.default_url_options = { host: ENV['API_DOMAIN_NAME'] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    # リモートメールサーバーを指定。デフォルトの"localhost"設定から必要に応じて変更
    address: ENV['SMTP_ADDRESS'],
    # メールサーバーが万一ポート25番で動作していない場合はここで変更
    port: ENV['SMTP_PORT'].to_i,
    # HELOドメインを指定する必要がある場合はここで行なう
    domain: ENV['SMTP_DOMAIN'],
    # メールサーバーで認証が要求される場合は、ここでユーザー名を設定
    user_name: ENV['SMTP_USER_NAME'],
    # メールサーバーで認証が要求される場合は、ここでパスワードを設定
    password: ENV['SMTP_PASSWORD'],
    # メールサーバーで認証が要求される場合は、ここで認証の種類を指定する
    # :plain、:login、:cram_md5のいずれかのシンボルを指定できる
    authentication: 'plain',
    # 利用するSMTPサーバーでSTARTTLSが有効かどうかを検出し、可能な場合は使う。デフォルト値はtrue
    enable_starttls_auto: true
    # SMTPサーバーにSTARTTLSで接続する（サポートされていない場合は失敗する）。デフォルト値はfalse
    # enable_starttls: false
    # TLSを使う場合、OpenSSLの認証方法を設定できる。これは、自己署名証明書やワイルドカード証明書が必要な場合に便利。
    # OpenSSLの検証定数である:noneや:peerを指定することも、OpenSSL::SSL::VERIFY_NONE定数や
    # OpenSSL::SSL::VERIFY_PEER定数を直接指定することもできる
    # openssl_verify_mode:
    # SMTP接続でSMTP/TLS（SMTPS: SMTP over direct TLS connection）を有効にします。
    # ssl/:tls:
    # コネクション開始の試行中の待ち時間を秒で指定します。
    # open_timeout:
    # 呼び出しのタイムアウトを秒で指定
    # read_timeout:
  }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Log disallowed deprecations.
  config.active_support.disallowed_deprecation = :log

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require "syslog/logger"
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Inserts middleware to perform automatic connection switching.
  # The `database_selector` hash is used to pass options to the DatabaseSelector
  # middleware. The `delay` is used to determine how long to wait after a write
  # to send a subsequent read to the primary.
  #
  # The `database_resolver` class is used by the middleware to determine which
  # database is appropriate to use based on the time delay.
  #
  # The `database_resolver_context` class is used by the middleware to set
  # timestamps for the last write to the primary. The resolver uses the context
  # class timestamps to determine how long to wait before reading from the
  # replica.
  #
  # By default Rails will store a last write timestamp in the session. The
  # DatabaseSelector middleware is designed as such you can define your own
  # strategy for connection switching and pass that into the middleware through
  # these configuration options.
  # config.active_record.database_selector = { delay: 2.seconds }
  # config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
  # config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session
end
