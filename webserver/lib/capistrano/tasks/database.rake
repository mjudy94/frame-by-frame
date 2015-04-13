namespace :deploy do
  namespace :db do
    desc "Run rake db:reset to drop and reseed the database"
    task :reset do
      on roles(:db) do |h|
        set :reset_answer, ask("if you really want to reset the production db? [yn]", "n")
        if fetch(:reset_answer).downcase == "y"
          within current_path do
            with rails_env: fetch(:rails_env) do
              rake "db:reset"
            end
          end
        end
      end
    end

    desc "Runs rake db:seed on the database"
    task :seed do
      on roles(:db) do |h|
        within current_path do
          with rails_env: fetch(:rails_env) do
            rake "db:seed"
          end
        end
      end
    end
  end
end
