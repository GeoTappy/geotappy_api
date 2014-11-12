app_env = ENV['RACK_ENV'] || 'production'
app_src = '/u/geotappy_api/current'

working_directory (app_env == 'production' ? "#{app_src}/current" : `pwd`.gsub("\n", ""))
worker_processes  (app_env == 'production' ? 10 : 4)
preload_app       true
timeout           30

if app_env == 'production'
  stderr_path "#{app_src}/shared/log/unicorn.log"
  stdout_path "#{app_src}/shared/log/unicorn.log"
else
  listen      8080

  app_root  = `pwd`.gsub("\n", "")
  pid         "#{app_root}/tmp/pids/unicorn.pid"
  stderr_path "#{app_root}/log/unicorn.log"
  stdout_path "#{app_root}/log/unicorn.log"
end
