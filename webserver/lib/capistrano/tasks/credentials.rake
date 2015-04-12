namespace :deploy do
  desc "Upload local unencrypted credential files"
  task :credentials do
    on roles(:all) do |h|
      upload! "/config/creds.yml", "#{deploy_to}/current/config"
    end
  end
end
