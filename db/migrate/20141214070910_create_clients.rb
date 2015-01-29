class CreateClients < Framework::Migration
  use_database :default

  def up
    create_table :clients do |t|
      t.string :name, null: false
      t.integer :local_account_amount, default: 0, null: false
      t.integer :rate_set_for_the_client, default: 0, null: false

      t.timestamps
    end
  end

  def down
    drop_table :clients
  end
end
