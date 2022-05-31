#coding: utf-8
class SemantictestsController < AdminToolsController
skip_before_filter :verify_authenticity_token
  def index

    @etalons = Etalon.all
  end
  
  def new
  end
  
  def setEtalonCheck
    @etalon = Etalon.find(params[:id])
    @etalon.check = params[:check]

    @etalon.save()
    render text: "Изменено"
  end
  
  def create 
    @etalon = Etalon.new()
    @etalon.name = params[:name]
    @etalon.save()
    redirect_to semantictests_path, notice: "Создано"
  end
  
  def show 
    @etalon = Etalon.find(params[:id])
  end
  
  def updateJson 
  	@etalon = Etalon.find(params[:id])
  	@etalon.etalonjson = params[:etalonjson]
  	@etalon.name = params[:name]
  	@etalon.nodejson = params[:namesjson]
  	@etalon.save()
  	render plain: 'Сохранено'
  end
  
  def results 
		@groups = Group.all
		@date_from =Time.now.to_date
		@date_to = Time.now.to_date
		if not params[:date].nil?
		  @date_from = params[:date][:from]
		  @date_to = params[:date][:to]
		end
		group = params[:group] || ""
		students = []
		if group == ""
		  group = Group.all
		  for i in 0..group.length - 1
		    for j in 0..group[i].students.length - 1
		      students.push(group[i].students[j].id)
		    end
		  end
		else
		  group = Group.find(params[:group])
		  for i in 0..group.students.length - 1
		    students.push(group.students[i].id)
		  end
		end
		@results = Semanticnetwork.where( :created_at => @date_from.to_date..@date_to.to_date.tomorrow).where(:student_id => students)
	end
  
end
