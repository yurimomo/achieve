class NotificationsController < ApplicationController
	before_action :authenticate_user!

  def index
  	  @notifications = Notification.where(user_id: current_user.id).where(read: false).order(created_at: :desc)
  end
end

# .where(read: false)で未読のみ表示
# .order(created_at: :desc) 新しい順に表示