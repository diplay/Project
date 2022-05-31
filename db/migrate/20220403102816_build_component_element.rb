class BuildComponentElement < ActiveRecord::Migration[5.0]
  def change
    add_reference :component_elements, :components, foreign_key: true, null: true
    add_reference :component_elements, :component_elements, foreign_key: true, null: true, column: :parent_id
  end
end
