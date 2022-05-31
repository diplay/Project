class AddRecData < ActiveRecord::Migration[5.0]
  def change
    add_column :recomendations, :data, :text, default: "{}"
  end
end
