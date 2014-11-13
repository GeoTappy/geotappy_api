class LocationShareJob
  include SuckerPunch::Job

  def perform(args = {})
    SuckerPunch.logger.debug args

    ActiveRecord::Base.connection_pool.with_connection do
      LocationShareService.call(args)
    end
  end
end
