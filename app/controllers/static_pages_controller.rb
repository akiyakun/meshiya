class StaticPagesController < ApplicationController
  def home
    if signed_in?
      # @micropost = current_user.microposts.build
      # @feed_items = current_user.feed.paginate( page: params[ :page ] )
      @micropost = current_user.microposts.build
      @aa = Micropost
      @feed_items = Micropost.paginate( page: params[ :page ] ).order( 'updated_at DESC' )
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
