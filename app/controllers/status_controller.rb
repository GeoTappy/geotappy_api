class StatusController < ApplicationController
  protect_from_forgery with: :null_session

  respond_to :json

  def lightweight
    if database_ok?
      head :ok
    else
      head :service_unavailable
    end
  end

  def health
    render json: health_status
  end

  private

  def health_status
    {
      database_ok: database_ok?,
      redis_ok:    redis_ok?,
      overall_ok:  overall_ok?,
      version:     GeotappyApi::VERSION
    }
  end

  def overall_ok?
    [database_ok?, redis_ok?].all?
  end

  def database_ok?
    begin
      ActiveRecord::Base.connected?
    rescue => e
      return false
    end
  end

  def redis_ok?
    Sidekiq.redis { |conn| conn.ping }
    true
  rescue => e
    Rails.logger.error e.message
    false
  end
end
