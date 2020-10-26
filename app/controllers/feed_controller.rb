class FeedController < ApplicationController
  def read
    @item = get_weighted_random_list_item()
  end

  private

  def get_weighted_random_list_item
    list_items = ListItem.all
  
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
