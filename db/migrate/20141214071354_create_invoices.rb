class CreateInvoices < Framework::Migration
  use_database :default

  def up
    create_table :invoices do |t|
      t.integer :amount
      t.references :client
      t.timestamps
    end
  end

  def down
    drop_table :invoices
  end
end
