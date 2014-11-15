require 'rails_helper'

describe FriendMatcher do
  let(:user) do
    FactoryGirl.create(:user_with_provider)
  end

  let(:people) do
    [
      FactoryGirl.create(:user_with_provider),
      FactoryGirl.create(:user_with_provider),
      FactoryGirl.create(:user_with_provider)
    ]
  end

  let(:matcher) { described_class.new(user, provider: :facebook) }


  let(:friends) do
    [
      { id: people[0].auth_providers.first.provider_account_id.to_s, name: 'test' },
      { id: people[2].auth_providers.first.provider_account_id.to_s, name: 'test' },
    ]
  end

  describe '#match' do
    context 'new friends' do
      it 'creates new friendship scoped to provider' do
        expect {
          matcher.match(friends)
        }.to change(UserFriendship, :count).by(4)
      end

      it 'assigns friends to given user' do
        matcher.match(friends)
        expect(user.friends).to match_array([people[0], people[2]])
      end
    end

    context 'existing friends' do
      before do
        UserFriendship.create_if_new(user, people[0])
      end

      it 'does not create doubled friendships' do
        expect {
          matcher.match(friends)
        }.to change(UserFriendship, :count).by(2)
      end

      it 'assigns friends to given user' do
        matcher.match(friends)
        expect(user.friends).to match_array([people[0], people[2]])
      end
    end

    context 'deleted friends' do
      before do
        UserFriendship.create_if_new(user, people[1])
      end

      it 'remove friendships from database' do
        expect {
          matcher.match([])
        }.to change(UserFriendship, :count).by(-2)
      end

      it 'remove not existing friendship from users' do
        matcher.match([])
        expect(user.friends).to_not include(people[1])
      end
    end

    context 'wtih friends, one to delete' do
      before do
        UserFriendship.create_if_new(user, people[0])
        UserFriendship.create_if_new(user, people[1])
      end

      it 'creates correct friendships' do
        matcher.match(friends)
        expect(user.friends).to match_array([people[0], people[2]])
      end
    end
  end
end
