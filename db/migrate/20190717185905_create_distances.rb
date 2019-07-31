class CreateDistances < ActiveRecord::Migration[5.2]
  def change
    create_table :distances do |t|
      t.string :origin
      t.string :destiny
      t.integer :distance
      t.references :map
      t.timestamps
    end
  end
end
