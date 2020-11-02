class AddUsernameAndArchivedToListItems < ActiveRecord::Migration[6.0]
  def change
    add_column :list_items, :username, :string
    add_column :list_items, :archived, :boolean, null: false, default: false
    change_column :list_items, :times_skipped, :integer, default: 100
  end
end
