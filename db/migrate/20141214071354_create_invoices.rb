class CreateInvoices < Framework::Migration
  use_database :default

  def up
    create_table :invoices do |t|
      t.integer :due_amount, default: 0, null: false
      t.integer :paid_amount, default: 0, null: false
      t.string :status, default: 'pending', null: false

      t.references :client, index: true
      t.references :job, index: true

      t.timestamps
    end
  end

  def down
    drop_table :invoices
  end
end
