class Users::FollowsController < UsersController
  def following
    @title = t ".title"
    @users = @user.following.paginate page: params[:page]
    @users_right = @user.following.paginate page: params[:page],
             per_page: Settings.size.s_10
    render :show_follow
  end

  def followers
    @title = t ".title"
    @users = @user.followers.paginate page: params[:page]
    @users_right = @user.followers.paginate page: params[:page],
            per_page: Settings.size.s_10
    render :show_follow
  end
end
