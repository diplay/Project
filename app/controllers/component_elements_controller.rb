class ComponentElementsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :check_admin

  layout "ka_application"
  
  def index
    
  end

  def create
    component = Component.find(params[:component_id])
    $c_element = ComponentElement.create(tag: params[:tag], name: params[:name], desc: params[:desc], components_id: params[:component_id])
    if params[:is_multiple].nil?
      $c_element.is_multiple = false
      $c_element.size = nil
    else
      $c_element.is_multiple = params[:is_multiple] == "on"
      $c_element.size = params[:size]
    end
    $c_element.save() 
    redirect_to component_edit_view_path(component)
  end

  def create_child
    $c_element = ComponentElement.create(tag: params[:tag], name: params[:name], desc: params[:desc], component_elements_id: params[:component_element_id])
    if params[:is_multiple].nil?
      $c_element.is_multiple = false
      $c_element.size = nil
    else
      $c_element.is_multiple = params[:is_multiple] == "on"
      $c_element.size = params[:size]
    end
    $c_element.save
    redirect_to component_element_path(ComponentElement.find(params[:component_element_id]))
  end

  def new
    print(params)
    $component = Component.find(params[:component_id])
  end

  def edit
    $c_element = ComponentElement.find(params[:component_element_id])
    $c_element.name = params[:name]
    $c_element.tag = params[:tag]
    $c_element.desc = params[:desc]
    if params[:is_multiple].nil?
      $c_element.is_multiple = false
      $c_element.size = nil
    else
      $c_element.is_multiple = params[:is_multiple] == "on"
      $c_element.size = params[:size]
    end
    $c_element.save
    redirect_to :back
  end

  def show
    $c_element = ComponentElement.find(params[:id])
    # print($c_element.is_multiple)
  end

  def new_child
    $c_element = ComponentElement.find(params[:component_element_id])
  end

  def destroy
    $c_element = ComponentElement.find(params[:component_element_id])
    $c_element.delete
    redirect_to :back
  end
end
