module Api
  module V1
    class ProfilesController < BaseController
      def show
        render json: current_user, serializer: ProfileSerializer
      end

      def create
        user = User.new(user_params)

        if user.save
          render json: user.to_json
        else
          render json: { errors: user.errors }
        end
      end

      def update
        current_user.update_attributes(user_params.except(:email))

        respond_with current_user
      end

      def token
        address = token_params[:token]

        mobile_device = current_user.mobile_devices.where(address: address).first_or_initialize

        if mobile_device.save
          DeviceRegistrationWorker.perform_async(
            mobile_device_id: mobile_device.id
          )

          render json: mobile_device, status: :created
        else
          render json: mobile_device.errors
        end
      end

      private

      def user_params
        params.require(:user).permit(
          :first_name, :last_name, :email, :birthdate, :cover_photo_url, :profile_photo_url,
          :password, :password_confirmation
        )
      end

      def token_params
        params.require(:user).permit(:token)
      end
    end
  end
end
