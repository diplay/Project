class AddComponentWeight2 < ActiveRecord::Migration[5.0]
  def change
    change_column :topic_components, :weight, :float, default: 0
    change_column :topic_components, :weight, :float, null: false
  end
end
