# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_runner_session',
  :secret      => 'e63b7a0a2c6a4fe033cedd7c6ed732186530f811daaa6497afba62f3a863794eeb2170b5df0f6760200679b70532fe6301f2bb9021dd44fdcbbc6e35e41ff551'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
