import Config

# Configuration de la base de données
config :time_manager_api, TimeManager.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "worktime_manager_prod",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Configuration du endpoint
config :time_manager_api, TimeManagerWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],  # Modifié pour permettre l'accès externe
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "WNnRq60fyH/BLMWMUjNnS1IxMyjhV7UofMnGCyHfmUmEAZAxUiyiGbbhaR9flryW",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:time_manager_api, ~w(--sourcemap=inline --watch)]}
  ]

# Ajout de la configuration CORS
config :cors_plug,
  origin: ["http://localhost:5173", "http://10.68.252.183:4000", "capacitor://localhost"],
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  headers: ["Authorization", "Content-Type", "Accept", "Origin", "User-Agent", "DNT", "Cache-Control", "X-Mx-ReqToken", "Keep-Alive", "X-Requested-With", "If-Modified-Since", "X-CSRF-Token"],
  credentials: true,
  max_age: 86400

# Le reste de votre configuration reste inchangé
config :time_manager_api, dev_routes: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :swoosh, :api_client, false
