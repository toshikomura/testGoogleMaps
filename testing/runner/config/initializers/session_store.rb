# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_runner_session',
  :secret      => 'c69be18724c33902da5343b88065c7e5a6444dd22884955a535ad79481c7abd8a18607c77dbf155ff5a5593693216aca0ecc1e3a97ab337b5fd6d398289bf38b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
