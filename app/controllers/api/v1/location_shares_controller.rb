module Api
  module V1
    class LocationSharesController < BaseController
      def create
        LocationShareJob.new.async.perform(
          location_share_params.merge(current_user: current_user)
        )

        render json: { status: :ok }
      end

      def location_share_params
        params.require(:location_share).permit(
          :title, user_ids: [], location: [:lat, :lng]
        )
      end
    end
  end
end
