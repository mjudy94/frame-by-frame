namespace :deploy do
  namespace :db do
    desc "Run rake db:reset to drop and reseed the database"
    task :reset do
      on roles(:db) do |h|
        set :reset_answer, ask("if you really want to reset the production db? [yn]", "n")
        if fetch(:reset_answer).downcase == "y"
          rake "db:reset"
        end
      end
    end

    desc "Runs rake db:seed on the database"
    task :seed do
      on roles(:db) do |h|
        rake "db:seed"
      end
    end
  end
end
