require 'pact_broker/tasks'

PactBroker::DB::MigrationTask.new do | task |
  ENV['RACK_ENV'] ||= 'test'
  require 'db'
  task.database_connection = DB::PACT_BROKER_DB
end

PactBroker::DB::VersionTask.new do | task |
  ENV['RACK_ENV'] ||= 'test'
  require 'db'
  task.database_connection = DB::PACT_BROKER_DB
end

PactBroker::DB::CleanTask.new do | task |
  ENV['RACK_ENV'] ||= 'test'
  require 'db'
  task.database_connection = DB::PACT_BROKER_DB
end
