# frozen_string_literal: true
namespace :db do
  namespace :migrate do
    desc 'Setup the db or migrate depending on state of db'
    task setup: :environment do
      begin
        if ActiveRecord::Migrator.current_version.zero?
          Rake::Task['db:migrate'].invoke
          Rake::Task['db:seed'].invoke
        end
      rescue ActiveRecord::NoDatabaseError
        Rake::Task['db:setup'].invoke
      else
        Rake::Task['db:migrate'].invoke
      end
    end
  end

  task :pre_migration_check do
    secret_key = ActiveRecord::Base.connection.select_one("select * from tom_settings")
    abort 'Something went wrong.' if secret_key.nil?
  end

  Rake::Task['db:migrate'].enhance(['db:pre_migration_check'])
end