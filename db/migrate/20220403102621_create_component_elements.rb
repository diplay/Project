class CreateComponentElements < ActiveRecord::Migration[5.0]
  def change
    create_table :component_elements do |t|
      t.string :tag
      t.text :desc

      t.timestamps
    end
  end
end
