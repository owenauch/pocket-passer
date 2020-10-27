class ListItem < ApplicationRecord
  validates :item_id, uniqueness: true

  def pass_article
    new_times_skipped = self.times_skipped + 1
    self.update(times_skipped: new_times_skipped)
  end

end
