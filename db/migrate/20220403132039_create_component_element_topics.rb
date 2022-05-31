class CreateComponentElementTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :component_element_topics do |t|

      t.timestamps
    end
  end
end
