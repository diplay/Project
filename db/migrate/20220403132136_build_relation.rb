class BuildRelation < ActiveRecord::Migration[5.0]
  def change
    add_reference :component_element_topics, :component_elements
    add_reference :component_element_topics, :ka_topics
  end
end
