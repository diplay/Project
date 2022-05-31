class TopicRelation < ActiveRecord::Base
  belongs_to :ka_topic
  belongs_to :related_topic, class_name: "KaTopic"

  def self.calculate_relation(top_a, top_b, constructs)
    if top_a.id != top_b.id
      has_same_constructs = false
      sum = 0
      constructs.each do |c|
        if top_a.topic_constructs.where(construct_id: c.id).count != 0 && top_b.topic_constructs.where(construct_id: c.id).count != 0
          sum += (top_a.topic_constructs.where(construct_id: c.id).take.mark - top_b.topic_constructs.where(construct_id: c.id).take.mark).abs ** 2
          has_same_constructs = true
        end
      end

      if constructs.count != 0
        sum = Math.sqrt(sum / constructs.count) / 100
        print "MY SUUUUUUUUUUUUM\n"
        print sum
        if has_same_constructs
          rel = TopicRelation.new(ka_topic_id: top_a.id, related_topic_id: top_b.id)

          if sum < 0.3
            rel[:rel_type] = 0
          elsif sum < 0.7
            rel[:rel_type] = 1
          else
            rel[:rel_type] = 2
          end

          return rel
        end
      end
    end
    return nil
  end
end
