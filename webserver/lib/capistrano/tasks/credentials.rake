namespace :deploy do
  desc "Upload local unencrypted credential files"
  task :credentials do
    on roles(:all) do |h|
      if not test "[ -d #{shared_path}/config ]"
        execute :mkdir, "#{shared_path}/config"
      end
      upload! "config/creds.yml", "#{shared_path}/config/creds.yml"
    end
  end
end
