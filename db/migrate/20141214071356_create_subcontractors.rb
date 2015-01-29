class CreateSubcontractors < Framework::Migration
  use_database :default

  def up
    create_table :subcontractors do |t|
      t.integer :rate, default: 0, null: false
      t.string :name, null: false

      t.timestamps
    end
  end

  def down
    drop_table :subcontractors
  end
end
