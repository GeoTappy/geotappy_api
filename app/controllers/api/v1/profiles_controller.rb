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

        if address.length != 64
          render json: { status: :error, message: 'invalid_token_size' }, status: 422
        else
          DeviceRegistrationJob.new.async.perform(
            user:    current_user,
            address: address
          )

          render json: { status: :ok }
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
