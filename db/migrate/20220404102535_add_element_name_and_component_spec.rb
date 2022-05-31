class AddElementNameAndComponentSpec < ActiveRecord::Migration[5.0]
  def change
    add_column :component_elements, :name, :string, default: ""
    add_column :components, :additional, :text, default: "{}"
  end
end
