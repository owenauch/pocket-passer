class CreateListItems < ActiveRecord::Migration[6.0]
  def change
    create_table :list_items do |t|
      t.string :item_id
      t.string :resolved_id
      t.string :given_url
      t.string :resolved_url
      t.string :given_title
      t.string :resolved_title
      t.integer :favorite
      t.integer :status
      t.text :exerpt
      t.integer :is_article
      t.integer :has_image
      t.integer :has_video
      t.integer :word_count

      t.timestamps
    end
  end
end
