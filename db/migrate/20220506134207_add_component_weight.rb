class AddComponentWeight < ActiveRecord::Migration[5.0]
  def change
    add_column :topic_components, :weight, :float 
  end
end
