class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @feed_items = Micropost.feed(current_user).recent_posts
                           .paginate page: params[:page],
                            per_page: Settings.size.s_10
  end

  def help; end

  def about; end

  def contact; end
end
