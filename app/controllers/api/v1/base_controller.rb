module Api
  module V1
    class BaseController < ApplicationController
      doorkeeper_for :all, unless: ->{ (controller_name == 'profiles' && action_name == 'create') || controller_name == 'stats' }

      protect_from_forgery with: :null_session
      skip_before_filter :verify_authenticity_token

      respond_to :json

      private

      def current_user
        return nil if doorkeeper_token.blank?

        @current_user ||= User.find(doorkeeper_token.resource_owner_id).tap do |u|
          Rails.logger.info "### User: #{u.id} #{u.first_name} #{u.last_name}" if u.present?
        end
      end
    end
  end
end

