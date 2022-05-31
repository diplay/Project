require "json"

class KaVariantsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout "ka_application"

  def check
    variant = KaVariant.find(params[:id])
    @error = 0
    # if KaResult.where(user_id: @user.id, ka_test_id: variant.ka_test.id).count > 0 and @user.role != "admin"
    #   @error = 1
    #   return
    # end

    @assessment = 0
    answers = {}
    params.each do |key, value|
      if key.include? "answer_id:"
        answers[key["answer_id:".length...key.length + 1]] = 1
      end
    end

    question_marks = {}
    questions = variant.ka_question.each
    questions.each do |q|
      question_marks[q.id] = { right_ans_count: 0.0, wrong_ans_count: 0.0, score: 0.0 }
      question_marks[q.id][:right_ans_count] = q.ka_answer.where(correct: 1).count
      question_marks[q.id][:wrong_ans_count] = q.ka_answer.where(correct: 0).count
    end

    answers.each do |a, _buf|
      ans = KaAnswer.find(a)
      if ans.correct != 0
        question_marks[ans.ka_question_id][:score] += 1.0 / question_marks[ans.ka_question_id][:right_ans_count]
      else
        question_marks[ans.ka_question_id][:score] -= 1.0 / question_marks[ans.ka_question_id][:wrong_ans_count]
      end
    end

    sum_score = 0.0
    sum_diff = 0.0

    topic_marks = {}

    questions.each do |q|
      topic_marks[q.ka_topic_id] = { sum_score: 0.0, sum_diff: 0.0, score: 0.0 }
    end

    questions.each do |q|
      sum_score += q.difficulty * question_marks[q.id][:score]
      sum_diff += q.difficulty

      topic_marks[q.ka_topic_id][:sum_score] += q.difficulty * question_marks[q.id][:score]
      topic_marks[q.ka_topic_id][:sum_diff] += q.difficulty
    end

    @assessment = sum_score / sum_diff
    @assessment *= 100.0
    if @assessment < 0
      @assessment = 0.0
    end
    @assessment = @assessment.to_i

    result = KaResult.new
    result.ka_variant_id = variant.id
    result.ka_test_id = variant.ka_test.id
    result.user_id = @user.id
    result.assessment = @assessment
    result.save

    ActiveRecord::Base.transaction do
      answers.each do |a, _buf|
        answer_log = KaAnswerLog.new
        answer_log.ka_result_id = result.id
        answer_log.ka_answer_id = a
        answer_log.save
      end

      competence_marks = {}

      topic_marks.each do |id, t|
        t[:score] = t[:sum_score] / t[:sum_diff]
        t[:score] = 0 if t[:score] < 0
        ProblemArea.create(ka_result_id: result.id, ka_topic_id: id, mark: t[:score])

        top = KaTopic.find(id)
        top.topic_competences.each do |c|
          if not competence_marks.has_key?(c.competence_id)
            competence_marks[c.competence_id] = { sum_score: 0.0, sum_weight: 0.0, score: 0.0 }
          end
          competence_marks[c.competence_id][:sum_score] += t[:score] * c.weight
          competence_marks[c.competence_id][:sum_weight] += c.weight
        end
      end

      competence_marks.each do |id, c|
        c[:score] = c[:sum_score] / c[:sum_weight]
        CompetenceCoverage.create(ka_result_id: result.id, competence_id: id, mark: c[:score])
      end

      tutor_actions_priorities = {}

      topic_marks.each do |id, t|
        topic_components = TopicComponent.where(ka_topic_id: id)
        topic_components.each do |tc|
          action_id = "component@%d" % tc.component_id
          if not tutor_actions_priorities.has_key?(action_id)
            tutor_actions_priorities[action_id] = { sum_score: 0.0, sum_weight: 0.0, score: 0.0 }
          end
          tutor_actions_priorities[action_id][:sum_score] += t[:score] * tc.weight
          tutor_actions_priorities[action_id][:sum_weight] += tc.weight
        end

        test_utz = TestUtzTopic.where(ka_topic_id: id)
        test_utz.each do |topic_utz|
          action_id = "test_utz@%d" % topic_utz.test_utz_question_id
          if not tutor_actions_priorities.has_key?(action_id)
            tutor_actions_priorities[action_id] = { sum_score: 0.0, sum_weight: 0.0, score: 0 }
          end
          tutor_actions_priorities[action_id][:sum_score] += topic_utz.weight * t[:score]
          tutor_actions_priorities[action_id][:sum_weight] += topic_utz.weight
        end
      end

      @tutor_actions = []
      tutor_actions_priorities.each do |action_id, p|
        id = action_id.split("@")[1].to_i
        type = action_id.split("@")[0]

        link = get_link(type, id)
        name = get_name(type, id)

        p[:score] = p[:sum_score] / p[:sum_weight] * 100

        if 100 - p[:score] > 30
          @tutor_actions.push({
            :cmp => id,
            :type => type,
            :name => name,
            :link => link,
            :priority => 100 - p[:score],
            :sum_weight => p[:sum_weight],
          })
        end
      end

      @tutor_actions.sort { |a, b| compare_actions(a, b) }
    end
  end

  def compare_actions(action_1, action_2)
    
    return action_1[:priority] <=> action_2[:priority]
  end

  def get_link(type, id)
    case type
    when "component"
      cmp = Component.find(id)
      return JSON.parse(cmp.additional)["link"]
    when "test_utz"
      return test_utz_question_path(id)
      # when "match_utz" для других утз аналогично
    end
  end

  def get_name(type, id)
    case type
    when "component"
      cmp = Component.find(id)
      return cmp.name
    when "test_utz"
      return TestUtzQuestion.find(id).text
      # when "match_utz" для других утз аналогично
    end
  end
end
