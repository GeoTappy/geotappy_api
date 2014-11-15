class LocationShareValidator
  include ActiveModel::Validations

  validates :lat,     presence: true, numericality: true
  validates :lng,     presence: true, numericality: true
  validates_each :user_ids do |record, attr, value|
    record.errors.add attr, 'no ids found' unless record.friends_exists?
  end
  validates :title,  length: { maximum: 128 }

  attr_reader :current_user, :user_ids, :lat, :lng, :title

  def initialize(params)
    @current_user = params[:current_user]
    @user_ids     = params[:user_ids]
    @location     = params[:location] || {}
    @lat          = @location[:lat]
    @lng          = @location[:lng]
    @title        = params[:title]
  end

  def friends_exists?
    UserFriendship.friends_exists?(current_user, user_ids)
  end
end
