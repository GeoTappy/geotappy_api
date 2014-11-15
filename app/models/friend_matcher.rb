class FriendMatcher
  class Friend
    include ActiveAttr::Attributes
    include ActiveAttr::MassAssignment

    attribute :id
    attribute :name
  end

  attr_accessor :user, :provider

  def initialize(user, opts = {})
    self.user     = user
    self.provider = opts[:provider].to_s
  end

  def match(friends)
    friends.map! {|f| Friend.new(f) }

    people = find_people(friends)

    create_friendships(people)
    remove_friendships(people)
  end

  private

  def find_people(friends_hash)
    AuthProvider.where(
      provider: provider,
      provider_account_id: friends_hash.map(&:id)
    )
  end

  def create_friendships(people)
    people.each do |friend|
      UserFriendship.create_if_new(user, friend)
    end
  end

  def remove_friendships(people)
    if people.blank?
      UserFriendship.remove_connections(user)
    else
      UserFriendship.where(
        '(user_id = :user_id AND friend_id not in (:friends_id)) OR (user_id not in (:friends_id) AND friend_id = :user_id)',
        user_id: user.id, friends_id: people.map(&:id)
      ).delete_all
    end
  end
end
