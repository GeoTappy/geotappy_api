module Api
  module V1
    class LocationSharesController < BaseController
      def create
        share_params    = location_share_params.merge(current_user: current_user)
        share_validator = LocationShareValidator.new(share_params)

        if share_validator.valid?
          LocationShareService.call(share_params)
          render json: { status: :ok }
        else
          render json: share_validator.errors
        end
      end

      def location_share_params
        params.require(:location_share).permit(
          :title, user_ids: [], location: [:lat, :lng]
        )
      end
    end
  end
end
