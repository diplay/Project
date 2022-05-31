#coding: utf-8
class OutcomesController < AdminToolsController
  def index
    @groups = []
    Group.find_each do |group|
      @groups << { "number" => group.number,
                   "show_ref" => "<a href=\"#{outcome_path(group)}\">Просмотр</a>" }
    end
  end

  def show
    @group = Group.find(params[:id])
    #    @students = []
    @results = []
    res = Hash.new
    @group.students.each do |student|
      fr_res = student.studentframes.last
      sem_res = student.semanticnetworks.last
      test_res = KaResult.where(user_id: student.user.id).last
      if sem_res.nil?
        res["sem_res"] = "-"
      else
        res["sem_res"] = sem_res.rating
      end
      if fr_res.nil?
        res["fr_res"] = "-"
      else
        res["fr_res"] = fr_res.result
      end
      if test_res.nil?
        res["test_res"] = "-"
      else
        res["test_res"] = test_res.assessment
      end
      @results << { "fio" => "<a href=\"#{outcome_recomendations_path(@group, student)}\">#{student.fio}</a>",
                    "sem_res" => res["sem_res"],
                    "fr_res" => res["fr_res"],
                    "test_res" => res["test_res"] }
    end
  end

  #    Student.where(group: @group).each do |student|
  #      @students << {"fio" => "<a href=\"#{group_student_path(@group, student)}\">#{student.fio}</a>",
  #                    "login" => student.user.login}
  #    end
  #  end

  def new
  end

  def create_rec
    r = Recomendation.create(student_id: params[:s_id], type_um: params[:type], done: false)
    if params[:type] == "ht"
      r.data = {
        :text => params[:text],
      }.to_json
    elsif params[:type] == "ett"
      r.data = {
        :text => params[:text],
        :ett_type => params[:ett_type],
        :ett_id => params[:ett_id],
      }.to_json
    elsif params[:type] == "cmp"
      r.data = {
        :text => params[:text],
        :link => params[:link],
      }.to_json
    end
    r.save
    redirect_to :back
  end

  def recomendations
    @student = Student.find(params[:s_id])
    test_res = KaResult.where(user_id: @student.user.id).last
    if !KaResult.where(user_id: @student.user.id).empty?
      $problem = []
      ProblemArea.where(ka_result_id: test_res.id).all.each do |prob|
        pr = Hash.new
        pr["k_id"] = prob.ka_topic_id
        pr["text"] = KaTopic.find(prob.ka_topic_id).text
        pr["mark"] = prob.mark.round(2)
        $problem.push(pr)
      end
    end

    $utzrecomendate = []
    $problem.each do |prob|
      if prob["mark"] < 0.67
        TestUtzQuestion.where(ka_topic_id: prob["k_id"]).all.each do |a|
          recd = Hash.new
          recd["text"] = a.text
          recd["ett_type"] = 0
          recd["ett_id"] = a.id
          $utzrecomendate.push(recd)
        end
      end
    end

    $probrecomendate = []

    $problem.each do |prob|
      if prob["mark"] < 0.67
        recd = Hash.new
        recd["text"] = KaTopic.find(prob["k_id"]).text
        $probrecomendate.push(recd)
      end
    end

    $cmp_recomendations = []

    $problem.each do |prob|
      if prob["mark"] < 0.67
        topic = KaTopic.find(prob["k_id"])
        if !topic.components.empty?
          topic.components.each do |c|
            $cmp_recomendations.push({
              :text => c.name,
              :additional => JSON.parse(c.additional),
              :date => "-",
            })
          end
        end
      end
    end

    $plane = []
    Recomendation.where("student_id = ? AND done = ?", params[:s_id], false).find_each do |rec|
      recd = Hash.new
      recd["type"] = rec.type_um
      recd["data"] = JSON.parse(rec.data)
	  recd["id"] = rec.id
      $plane.push(recd)
    end
  end

  def delrecomendation
    print("--------////--------")
    print(params[:id])
    print("--------////--------")
    Recomendation.find(params[:id]).delete
    #	$semrecomendate.delete_if{|o| o[:id] == params[:id].to_i}
    #	redirect_to :back

    #	Recomendation.find(params[:id]).delete
    #	$frmsemrecomendate.delete_if{|o| o[:id] == params[:id].to_i}
    redirect_to :back
  end

  def changedate
    print("--------////--------")
    print(params[:date])
    $semrecomendate.each do |rec|
      Recomendation.find(rec["id"]).update(date: params[:date], rec_status: "DEFERRED")
    end

    $frmrecomendate.each do |rec|
      Recomendation.find(rec["id"]).update(date: params[:date], rec_status: "DEFERRED")
    end

    $probrecomendate.each do |rec|
      Recomendation.find(rec["id"]).update(date: params[:date], rec_status: "DEFERRED")
    end

    $utzrecomendate.each do |rec|
      Recomendation.find(rec["id"]).update(date: params[:date], rec_status: "DEFERRED")
    end
    print("--------////--------")
    redirect_to :back
  end

  def assign
    $semrecomendate.each do |rec|
      Recomendation.find(rec["id"]).update(date: nil, rec_status: "ASSIGNED")
    end

    $frmrecomendate.each do |rec|
      Recomendation.find(rec["id"]).update(date: nil, rec_status: "ASSIGNED")
    end

    $probrecomendate.each do |rec|
      Recomendation.find(rec["id"]).update(date: nil, rec_status: "ASSIGNED")
    end
    $utzrecomendate.each do |rec|
      Recomendation.find(rec["id"]).update(date: nil, rec_status: "ASSIGNED")
    end
    redirect_to :back
  end

  def cancel
    $semrecomendate.each do |rec|
      Recomendation.find(rec["id"]).update(date: nil, rec_status: "CANCELED")
    end

    $frmrecomendate.each do |rec|
      Recomendation.find(rec["id"]).update(date: nil, rec_status: "CANCELED")
    end

    $probrecomendate.each do |rec|
      Recomendation.find(rec["id"]).update(date: nil, rec_status: "CANCELED")
    end
    $utzrecomendate.each do |rec|
      Recomendation.find(rec["id"]).update(date: nil, rec_status: "CANCELED")
    end
    redirect_to :back
  end

  ##______________________________________________________________________________________##
  def execute
    session[:planning_task_id] = params[:planning_task_id]
    redirect_to action: "index"
  end

  def commit
    task = PlanningTask.find(session[:planning_task_id])
    transition = PlanningState::TransitionDescriptor.new
    transition.from = 1
    transition.to = 3
    task.state_atom.transit_to transition
    current_planning_session().commit_task(task)
    session[:planning_task_id] = nil

    redirect_to "/"
  end

  def update
  end

  def create
  end

  def edit
  end
end
