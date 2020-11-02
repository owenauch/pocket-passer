class FeedController < ApplicationController
  def read
    if session[:viewed_article_ids].nil?
      session[:viewed_article_ids] = []
    end

    list_items = ListItem.where(username: session[:username], archived: false)

    # keep sampling until we find one we haven't seen this session 
    item_to_read = nil
    loop do
      item_to_read = get_weighted_random_list_item(list_items)

      # handle case where we redirect to auth
      if item_to_read.nil?
        return
      end

      break if not session[:viewed_article_ids].include? item_to_read.item_id
    end

    @item = item_to_read

    # add this article to the ones we've seen this session
    session[:viewed_article_ids] = session[:viewed_article_ids] << @item.item_id
  end

  def skip_article
    @item = ListItem.find_by(item_id: params[:list_item_id])
    @item.pass_article
    redirect_to :controller => 'feed', :action => 'read'
  end

  def archive
    @item = ListItem.find_by(item_id: params[:list_item_id])
    @item.archive(session[:access_token])
    redirect_to :controller => 'feed', :action => 'read' and return
  end

  private

  def get_weighted_random_list_item(list_items)
    # send back to auth if not in session state
    if session[:username].nil?
      redirect_to :controller => 'pocket', :action => 'auth'
    end

    # add or reset viewed articles
    if session[:viewed_article_ids].length() === list_items.length()
      session[:viewed_article_ids] = []
    end

    # if no list items, show alert
    if list_items.empty?
      # sorry that this is gross
      flash.now.alert = "No articles found in Pocket list! — <a href='/pocket/load_feed'>Reload articles from Pocket</a>"
    end

    cumulative_weight = 0.0
    list_items.each do | item |
      cumulative_weight += 1.0/2**item.times_skipped
    end

    # we want this to be a float
    random_weight = rand * cumulative_weight

    counting_weight = 0.0
    list_items.each do | item |
      counting_weight += 1.0/2**item.times_skipped
      if random_weight < counting_weight
        return item
      end
    end

    # if our numbers get so small that we are rounding to 0 and it would
    # cause us to throw, just pick a random article
    # we're not landing on the moon here
    return list_items.sample
  end
end
