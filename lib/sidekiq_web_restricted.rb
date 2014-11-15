require 'sidekiq/web'

class SidekiqWebRestricted < Sidekiq::Web
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == 'admin' && password == Settings.sidekiq.password
  end
end
