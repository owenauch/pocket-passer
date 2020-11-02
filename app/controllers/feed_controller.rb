class FeedController < ApplicationController
  def read
    @item = get_weighted_random_list_item()
  end

  def skip_article
    @item = ListItem.find_by(item_id: params[:list_item_id])
    @item.pass_article
    redirect_to :controller => 'feed', :action => 'read'
  end
  
  def archive
    @item = ListItem.find_by(item_id: params[:list_item_id])
    @item.archive(session[:access_token])
    redirect_to :controller => 'feed', :action => 'read'
  end

  private

  def get_weighted_random_list_item
    # send back to auth if not in session state
    if session[:username].nil?
      redirect_to :controller => 'pocket', :action => 'auth'
    end
 
    list_items = ListItem.where(username: session[:username], archived: false)

    # if no list items, show alert
    if list_items.empty?
      flash.alert = "No articles found in Pocket list!"  
    end

    cumulative_weight = 0.0
    list_items.each do | item |
      cumulative_weight += 1.0/2**item.times_skipped
    end

    # we want this to be a float
    random_weight = rand(cumulative_weight.to_f)

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
