# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_shiojirigomi_session',
  :secret      => 'a76c2b93583205ca57afb9701603ecb2eae8438e39f6a43d1b90ca67415fa5242a6e8b7c752a52b26fc70072c0eff57ebd4ed1ca74a480f0b4f29cb64caeee2e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
