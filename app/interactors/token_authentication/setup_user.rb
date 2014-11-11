class TokenAuthentication
  class SetupUser
    include Interactor

    def call
      if user.present?
        context.user = user
      elsif user_with_email.present?
        context.user = user_with_email
      else
        password = Devise.friendly_token.first(12)
        context.user = User.new(
          email:                 context.fetcher.email,
          password:              password,
          password_confirmation: password
        )
      end
    end

    private

    def user
      @user ||= context.auth_provider.user
    end

    def user_with_email
      @user_with_email ||= User.with_email(context.fetcher.email)
    end
  end
end
