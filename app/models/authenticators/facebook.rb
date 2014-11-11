module Authenticators
  class Facebook < Base
    def authenticate
      begin
        auth = facebook_token_authentication

        if auth && auth.user && auth.user.persisted?
          auth.user
        else
          Rails.logger.error auth
          nil
        end
      rescue Faraday::Error => e
        MessageLogger.print_error(e)
        return nil
      end
    end

    private

    def facebook_token_authentication
      TokenAuthentication.call(auth_params)
    end

    def auth_params
      {
        token: params[:token],
        provider: 'facebook'
      }
    end
  end
end
