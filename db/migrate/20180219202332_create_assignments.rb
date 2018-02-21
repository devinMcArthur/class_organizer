class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.string :title
      t.text :description
      t.datetime :due_date
      t.integer :course_id

      t.timestamps
    end
  end
end
