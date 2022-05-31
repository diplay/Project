#coding: utf-8
class OutrecsController < ActionController::Base
  def index
  end

  def show
  end

  #    Student.where(group: @group).each do |student|
  #      @students << {"fio" => "<a href=\"#{group_student_path(@group, student)}\">#{student.fio}</a>",
  #                    "login" => student.user.login}
  #    end
  #  end

  def new
  end

  def done
    Recomendation.find(params[:id]).update(done: true)
    redirect_to :back
  end

  def plan
    @student = Student.find(params[:s_id])
    $plane = []
    Recomendation.where("student_id = ? AND done = ?", params[:s_id], false).find_each do |rec|
      recd = Hash.new
      recd["type"] = rec.type_um
      recd["data"] = JSON.parse(rec.data)
      recd["id"] = rec.id
      $plane.push(recd)
    end
  end

  def create
  end

  def edit
  end

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
end
