class AuthProvider < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :provider, allow_blank: true
end
