class ComponentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :check_admin

  layout "ka_application"

  def index
  end

  def create
    Component.create(name: params[:name])
    redirect_to :back
  end

  def show

    # def edit
    #   @component = Component.find(params[:id])
    # end

    # def update
    #   component = Component.find(params[:id])
    #   component.update(name: params[:name])
    #   redirect_to components_path
  end

  def destroy

    #    if !TopicComponent.where(component_id: params[:id]).empty?
    #	@top = TopicComponent.where(component_id: params[:id])
    #	@top.find_each do |t|
    #	    t.destroy
    #	end
    #    end

    #TopicComponent.where("component_id = ?",params[:id]).destroy
    Component.find(params[:id]).destroy
    redirect_to :back
  end

  def attach
    mas = []
    $out = []
    mas.push(params[:topic_id].to_i)
    limit = params[:rad].to_i
    weight = params[:weight]
    f = params[:flag].to_i
    count = 0
    while count < limit
      mas = mas.uniq
      for i in 0..mas.length - 1
        KaTopic.where("id = ? OR parent_id = ?", mas[i], mas[i]).find_each do |top|
          if !TopicRelation.where(ka_topic_id: top.id, related_topic_id: top.parent_id, rel_type: params[:rel]).empty? || !TopicRelation.where(ka_topic_id: top.parent_id, related_topic_id: top.id, rel_type: params[:rel]).empty?
            mas.push(top.id)
            mas.push(top.parent_id)
            mas = mas.uniq
          end
        end
        mas = mas.uniq
      end
      count = count + 1
    end
    mas = mas.uniq
    for i in 0..mas.length
      if TopicComponent.where(ka_topic_id: mas[i], component_id: params[:component_id]).empty? && !params[:component_id].nil?
        TopicComponent.create(ka_topic_id: mas[i], component_id: params[:component_id], weight: weight)
      else
        t = TopicComponent.find_by(ka_topic_id: mas[i], component_id: params[:component_id])
        t.weight = weight
        t.save()
      end
    end
    #    if TopicComponent.where(ka_topic_id: params[:topic_id], component_id: params[:component_id]).empty? && !params[:component_id].nil?
    #      TopicComponent.create(ka_topic_id: params[:topic_id], component_id: params[:component_id])
    #    end

    #    redirect_to :back
    #  end

    for i in 0..mas.length - 1
      topic = KaTopic.find(mas[i])
      component = Component.find(params[:component_id])
      $out.push({ topic: topic.text, related_component: component.name, t_id: topic.id, c_id: component.id })
    end
    @r_id = params[:topic_id].to_i
    #     render :show_all_relations
    redirect_to :back
  end

  def show_all_relations
  end

  def detach_list
    #Внимание: используется delete_all (т.к. у модели нет первичных ключей)
    TopicComponent.delete_all(ka_topic_id: params[:t_id], component_id: params[:c_id])
    #    $out.delete({t_id: :t_id, c_id: :c_id})
    $out.delete_if { |o| o[:t_id] == params[:t_id].to_i }
    #    print($out[0].value?(params[:t_id].to_i))
    #    print(params[:t_id])
    render :show_all_relations
  end

  def detach
    #Внимание: используется delete_all (т.к. у модели нет первичных ключей)
    TopicComponent.delete_all(ka_topic_id: params[:t_id], component_id: params[:c_id])
    redirect_to :back
  end

  def edit_component_view
    $component = Component.find(params[:c_id])
    $services = ComponentService.where(component_id: params[:c_id])
    print($services.count)
    render :component_edit_view
  end

  def rename_component
    print(params)
    component = Component.find(params[:c_id])
    component.name = params[:name]
    component.save()
    redirect_to :back
  end

  def update_component
    component = Component.find(params[:c_id])
    component.additional = params[:additional]
    component.save()
    redirect_to :back
  end

  def create_service
    ComponentService.create(name: params[:name], component_id: params[:c_id], actor: params[:actor], path: params[:path], need_to_graduate: params[:need_to_graduate], priority: params[:priority])
    redirect_to :back
  end
end
