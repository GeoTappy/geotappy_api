module Api
  module V1
    class StatsController < BaseController
      def show
        stats = {
          global: {
            users: User.count,
            shares: Share.count,
            user_friendships: (UserFriendship.count / 2)
          },
          today: {
            users: User.where('created_at >= ?', DateTime.now.beginning_of_day).count,
            shares: Share.where('created_at >= ?', DateTime.now.beginning_of_day).count
          },
          profile: {
            friends: current_user.friends.count,
            shares:  current_user.shares.count,
            received_shares: current_user.user_shares.count,
            mobile_devices: current_user.mobile_devices.count
          }
        }

        render json: { stats: stats }
      end
    end
  end
end
