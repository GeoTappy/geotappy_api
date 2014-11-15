class MobileDevice < ActiveRecord::Base
  belongs_to :user

  validates :address, presence: true, length: { is: 64 }
end
