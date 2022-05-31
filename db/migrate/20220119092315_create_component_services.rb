class CreateComponentServices < ActiveRecord::Migration[5.0]
  def change
    create_table :component_services do |t|
      t.string :name
      t.integer :actor
      t.string :path
      t.references :component, foreign_key: true
      t.boolean :need_to_graduate
      t.integer :priority

      t.timestamps
    end
  end
end
