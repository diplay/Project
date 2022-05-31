class EditComponentElement < ActiveRecord::Migration[5.0]
  def change
    add_column :component_elements, :is_multiple, :boolean, default: false
    add_column :component_elements, :size, :integer, null: true
  end
end
