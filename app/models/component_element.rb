class ComponentElement < ApplicationRecord
    belongs_to :component
    belongs_to :component_element
    has_many :component_elements, foreign_key: "component_elements_id"
    has_many :ka_topics, through: :component_element_topic

    def get_json_tree
        root = {:id => self.id, :is_multiple => self.is_multiple, :size => self.size, :name => self.name, :tag => self.tag, :desc => self.desc, :children => []}
        self.component_elements.each do |c|
            root[:children].append(c.get_json_tree)
        end
        return root
    end
end
