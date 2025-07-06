class CreateApiClients < ActiveRecord::Migration[8.0]
  def change
    create_table :api_clients do |t|
      t.string :name
      t.string :api_token

      t.timestamps
    end
    add_index :api_clients, :api_token
  end
end
