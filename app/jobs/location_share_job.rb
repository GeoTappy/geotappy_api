class LocationShareJob
  include SuckerPunch::Job
  workers 4

  def perform(*args)
    debug args

    ActiveRecord::Base.connection_pool.with_connection do
      LocationShareService.call(args)
    end
  end
end
