class CreateUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :urls do |t|
      t.string :original_url
      t.string :short_code

      t.timestamps
    end
    add_index :urls, :short_code
  end
end
