class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :load_follow, only: :show

  def index
    @users = User.actived.paginate page: params[:page],
                  per_page: Settings.size.s_10
  end

  def show
    redirect_to root_path && return unless @user.activated?

    @microposts = @user.microposts.paginate page: params[:page],
                        per_page: Settings.size.s_10
  end

  def edit; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:success] = t ".welcome"
      redirect_to @user
    else
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      flash[:danger] = t ".danger"
      render :edit
    end
  end

  def destroy
    @user.destroy ? (flash[:success] = t ".success") :
                    (flash[:danger] = t ".danger")

    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit User::USER_TYPE
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.danger_user"
    redirect_to root_path
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "users.danger_login"
    redirect_to login_path
  end

  def correct_user
    return if current_user? @user

    redirect_to @user
    flash[:danger] = t "users.danger_permission"
  end

  def admin_user
    return if current_user.admin?

    redirect_to root_path
    flash[:danger] = t "users.danger_permission"
  end

  def load_follow
    @user_follow = current_user.active_relationships.build
    @user_unfollow = current_user.active_relationships
                                 .find_by(followed_id: @user.id)
    return if @user_follow || @user_unfollow

    redirect_to root_path
    flash[:danger] = t "users.danger_user"
  end
end
