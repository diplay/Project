class KaResultsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout "ka_application"
  
  def index
  end

  def show
    test_id = params[:test_id]
    @test = KaTest.find(test_id)
  end

  def recalc
    test_id = params[:id]
    test = KaTest.find(test_id)

    test.ka_results.each do |r|
      answers = []
      r.ka_answer_logs.each do |al|
        answers.push(al.ka_answer_id)
      end
      variant = r.ka_variant
      detail_result = KaDetailResult.new(variant, answers)
      r.assessment = detail_result.assessment
      r.save

      #Юзаются такие костыли, т.к. у ProblemArea и CompetenceCoverage нет ключей
      detail_result.problem_areas.each do |id, mark|
        ProblemArea.update_all("mark = #{mark} WHERE ka_result_id = #{r.id} AND ka_topic_id = #{id}")
      end

      detail_result.competence_coverages.each do |id, mark|
        CompetenceCoverage.update_all("mark = #{mark} WHERE ka_result_id = #{r.id} AND competence_id = #{id}")
      end
    end

    redirect_to :back
  end

  def detail
    result_id = params[:result_id]
    @result = KaResult.find(result_id)
    @student = @result.user.student

    answers = []
    @result.ka_answer_logs.each do |al|
      answers.push(al.ka_answer_id)
    end

    @detail_result = KaDetailResult.new(@result.ka_variant, answers)
  end

  def show_problem_areas_and_competences_coverage
    @test = KaTest.find(params[:test_id])

    users_ids = KaResult.where(ka_test_id: @test.id).distinct.pluck(:user_id)
    students_ids = User.where(:id => users_ids).distinct.pluck(:student_id)
    groups_ids = Student.where(:id => students_ids).distinct.pluck(:group_id)
    @groups = Group.find(groups_ids)
  end
  
end
