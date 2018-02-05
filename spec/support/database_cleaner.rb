#
# rspec-fails, Capybara, database_cleaner strategy.
#
# From http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/
# See also https://coderwall.com/p/ahtb7w
#
# Note: must change the following line in spec/spec_helper.rb...
#
# From...
#
# config.use_transactional_fixtures = true
#
# To...
#
# config.use_transactional_fixtures = false # <-- Change this to 'false'
#
RSpec.configure do |config|
  #
  # If you're not using ActiveRecord, or you'd prefer not to run
  # each of your examples within a transaction, remove the following
  # line or assign false instead of true.
  config.use_transactional_fixtures = true

  #
  # Clean up and initialize database before
  # running test exmaples.
  config.before(:suite) do
    #
    # Truncate database to clean up garbage from
    # interrupted or badly written examples.
    DatabaseCleaner.clean_with(:truncation)

    #
    # https://coderwall.com/p/ahtb7w
    #
    # Seed dataase. Use it only for essential
    # to run application data.
    load "#{Rails.root}/db/seeds.rb"
  end

  #
  # Use really fast transaction strategy for all
  # examples...
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  #
  # ...except `js: true` capybara specs.
  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    #
    # Start transaction.
    DatabaseCleaner.start
  end

  config.after(:each) do
    #
    # Rollback transaction.
    DatabaseCleaner.clean
  end

  #
  # ttps://coderwall.com/p/ahtb7w
  config.after(:each) do
    #
    # Clear session data.
    Capybara.reset_sessions!
  end
end
