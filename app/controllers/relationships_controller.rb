class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create
  before_action :load_relationship, only: :destroy

  def create
    current_user.follow @user
    @user_unfollow = current_user.active_relationships
                                 .find_by(followed_id: @user.id)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow @user
    @user_follow = current_user.active_relationships.build
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t "relationships.danger_user"
    redirect_to root_path
  end

  def load_relationship
    @user = Relationship.find_by(id: params[:id])
    return @user = @user.followed if @user

    flash[:danger] = t "relationships.danger_user"
    redirect_to root_path
  end
end
