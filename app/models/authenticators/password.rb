module Authenticators
  class Password < Base
    def authenticate
      user if user.present? && user.valid_password?(password)
    end

    private

    def user
      @user ||= User.with_email(email)
    end

    def email
      params[:email]
    end

    def password
      params[:password]
    end
  end
end
