class CreateJobs < Framework::Migration
  use_database :default

  def up
    create_table :jobs do |t|
      t.string :status, default: 'new', null: false
      t.date :start_date, null: false
      t.date :end_date

      t.references :client, index: true
      t.references :subcontractor, index: true

      t.timestamps
    end
  end

  def down
    drop_table :jobs
  end
end
