class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page]
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".welcome"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t ".success"
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit :email, :name, :password, :password_confirmation
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
    redirect_to @user unless current_user? @user
    flash[:danger] = t "users.danger_permission"
  end

  def admin_user
    redirect_to root_path unless @user.admin?
    flash[:danger] = t "users.permission"
  end
end
