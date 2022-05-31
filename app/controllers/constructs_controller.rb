class ConstructsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :check_admin

  layout "ka_application"

  def index
  end

  def create
    Construct.create(name: params[:name])
    redirect_to :back
  end

  def edit
    @construct = Construct.find(params[:id])
  end

  def update
    construct = Construct.find(params[:id])
    construct.update(name: params[:name])
    redirect_to constructs_path
  end

  def destroy
    Construct.find(params[:id]).destroy
    redirect_to :back
  end

  def attach
    if TopicConstruct.where(ka_topic_id: params[:topic_id], construct_id: params[:construct_id]).empty? && !params[:construct_id].nil?
      TopicConstruct.create(ka_topic_id: params[:topic_id], construct_id: params[:construct_id], mark: params[:mark])
    else
      TopicConstruct.where(ka_topic_id: params[:topic_id], construct_id: params[:construct_id]).update_all(mark: params[:mark].to_i)
    end

    redirect_to :back
  end

  def detach
    #Внимание: используется delete_all (т.к. у модели нет первичных ключей)
    TopicConstruct.delete_all(ka_topic_id: params[:t_id], construct_id: params[:c_id])
    redirect_to :back
  end
end
