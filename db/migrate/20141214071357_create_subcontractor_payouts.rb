class CreateSubcontractorPayouts < Framework::Migration
  use_database :default

  def up
    create_table :subcontractor_payouts do |t|
      t.integer :amount, default: 0, null: false
      t.references :subcontractor, index: true
      t.references :job, index: true

      t.timestamps
    end
  end

  def down
    drop_table :subcontractor_payouts
  end
end
