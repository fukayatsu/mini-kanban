class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :memo
      t.string :status, default: 'todo'
      t.datetime :started_at
      t.datetime :done_at

      t.timestamps
    end
  end
end
