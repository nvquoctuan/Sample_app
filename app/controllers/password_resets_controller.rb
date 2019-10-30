class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".info"
      redirect_to root_path
    else
      flash.now[:danger] = t ".danger"
      render :new
    end
  end

  def edit; end

  def update
    @user.assign_attributes user_params
    if @user.save context: :reset_pass
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit User::PASSWORD_RESET
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "password_resets.danger_email"
    redirect_to login_path
  end

  def valid_user
    redirect_to root_path unless @user&.activated? && @user&.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".password_resets.danger_expired"
    redirect_to new_password_reset_path
  end
end
