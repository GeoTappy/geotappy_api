module Api
  module V1
    class BaseController < ApplicationController
      doorkeeper_for :all, unless: ->{ controller_name == 'profiles' && action_name == 'create' }

      protect_from_forgery with: :null_session

      respond_to :json

      private

      def current_user
        @current_user ||= User.find(doorkeeper_token.resource_owner_id).tap do |u|
          Rails.logger.info "### User: #{u.id} #{u.first_name} #{u.last_name}" if u.present?
        end
      end
    end
  end
end

