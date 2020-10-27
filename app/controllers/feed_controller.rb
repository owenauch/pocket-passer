class FeedController < ApplicationController
  def read
    @item = get_weighted_random_list_item()
  end

  def skip_article
    @item = ListItem.find_by(item_id: params[:list_item_id])
    @item.pass_article
    puts "times skipped" + @item.times_skipped.to_s
    redirect_to :controller => 'feed', :action => 'read'
  end

  private

  def get_weighted_random_list_item
    list_items = ListItem.where(username: session[:username])
    cumulative_weight = 0
    list_items.each do | item |
      cumulative_weight += 1/2**item.times_skipped
    end

    random_weight = rand(cumulative_weight)

    counting_weight = 0
    list_items.each do | item |
      counting_weight += 1/2**item.times_skipped
      if random_weight < counting_weight
        return item
      end
    end
  end
end
