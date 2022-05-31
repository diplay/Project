class Component < ActiveRecord::Base
 has_many :topic_components, dependent: :delete_all
 has_many :ka_topics, through: :topic_components
 has_many :component_services
 has_many :component_elements, foreign_key: "components_id"

 def get_elements_tree
    tree = []
    self.component_elements.each do |c|
        tree.append(c.get_json_tree)
    end
    return tree
 end
end
