class CompetencesController < ApplicationController
  include PlanningHelper
  skip_before_filter :verify_authenticity_token
  before_action :check_admin

  layout "ka_application"

  def index
    if (session[:planning_task_id] != nil)
      @task = PlanningTask.find(session[:planning_task_id])
    end
  end

  def self.create_extension
    ext = ExtensionDatabase::ATExtension.new
    ext.ext_type = ExtensionDatabase::ExtensionType::Other
    ext.description = "Компонент построения модели компетенций"
    ext.tasks = ["competences-development-step"]

    ext.generate_state = lambda { |mode_id, week_id, schedule, state|
      atom = StateFacts.create(
        task_name: "competences-development-step",
        state: 1,
      )
      state.atoms.push << atom
    }

    ext.task_description = lambda { |leaf_id|
      return "Построение модели компетенций"
    }

    ext.task_exec_path = lambda { |pddl_act, leaf_id|
      if ((pddl_act == "execute-development-step") && (leaf_id == "competences-development-step"))
        return { "controller" => "competences", "params" => {} }
      else
        return {}
      end
    }

    return ext
  end

  def create
    Competence.create(code: params[:code], description: params[:description])
    redirect_to :back
  end

  def edit
    @competence = Competence.find(params[:id])
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
    competence = Competence.find(params[:id])
    competence.update(code: params[:code], description: params[:description])
    redirect_to competences_path
  end

  def destroy
    Competence.find(params[:id]).destroy
    redirect_to :back
  end

  def attach
    if TopicCompetence.where(ka_topic_id: params[:topic_id], competence_id: params[:competence_id]).empty? && !params[:competence_id].nil?
      TopicCompetence.create(ka_topic_id: params[:topic_id], competence_id: params[:competence_id], weight: params[:weight])
    else
      TopicCompetence.where(ka_topic_id: params[:topic_id], competence_id: params[:competence_id]).update_all(weight: params[:weight])
    end

    redirect_to :back
  end

  def detach
    #Внимание: используется delete_all (т.к. у модели нет первичных ключей)
    TopicCompetence.delete_all(ka_topic_id: params[:t_id], competence_id: params[:c_id])
    redirect_to :back
  end
end
