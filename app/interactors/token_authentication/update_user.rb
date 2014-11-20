class TokenAuthentication
  class UpdateUser
    include Interactor

    def call
      user.assign_attributes(fetcher.user_attributes)
      user.auth_providers << auth_provider unless user.auth_providers.include?(auth_provider)
      user.update_tracked_fields(request)
      user.save
    rescue => e
      Rails.logger.error e.message
      context.fail(error: e.message)
    end

    private

    def fetcher
      context.fetcher
    end

    def user
      context.user
    end

    def auth_provider
      context.auth_provider
    end

    def request
      context.request
    end
  end
end
