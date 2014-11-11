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
      overall_ok: overall_ok?
    }
  end

  def database_ok?
    begin
      ActiveRecord::Base.connected?
    rescue => e
      return false
    end
  end

  def overall_ok?
    [database_ok?].all?
  end
end
