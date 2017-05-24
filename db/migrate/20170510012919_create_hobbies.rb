class CreateHobbies < ActiveRecord::Migration[5.0]
  def change
    create_table :hobbies do |t|
      t.string :name
      t.references :student, foreign_key: true

      t.timestamps
    end
  end
end
