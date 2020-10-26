class ListItem < ApplicationRecord
  validates :item_id, uniqueness: true

  def pass_article
    self.times_skipped += 1
  end

end
