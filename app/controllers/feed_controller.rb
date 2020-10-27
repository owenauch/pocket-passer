class FeedController < ApplicationController
  def read
    @item = get_weighted_random_list_item()
  end

  def skip_article
    @item = ListItem.find_by(item_id: params[:list_item_id])
    @item.pass_article
    redirect_to :controller => 'feed', :action => 'read'
  end

  private

  # TODO: this should probably go in a helper at some point
  def get_weighted_random_list_item
    list_items = ListItem.where(username: session[:username])
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
