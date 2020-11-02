class CreateListFetchEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :list_fetch_events do |t|

      t.timestamps
    end
  end
end
