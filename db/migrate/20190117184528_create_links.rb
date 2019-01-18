class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.text :title, null: true
      t.text :description, null: true
      t.text :url, null: false
      t.integer :counter, default: 0
      t.timestamps
    end

    add_index :links, :url
  end
end
