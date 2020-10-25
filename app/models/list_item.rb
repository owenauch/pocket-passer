class ListItem < ApplicationRecord
  validates :item_id, uniqueness: true
end
