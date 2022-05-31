#coding: utf-8
class SemanticanswersController < ActionController::Base

include PlanningHelper


  def index
  		# @user = User.find (session["user_id"])
  		# if (@user.role == "admin")
  		# 	@tests = Semanticnetwork.all
	
  		# else
  		# 	redirect_to :root
  		# end
    render :start_page
  end

  def execute
    session["planning_task_id"] = params[:planning_task_id]
    create
  end
	
  def create 
    @semantic = Semanticnetwork.new()
    @semantic.rating = 0;
    @semantic.etalon = Etalon.where(:check => true).order("RANDOM()").first

    @semantic.json = ""
    @semantic.student = User.find(session[:user_id]).student
    @semantic.save()

    redirect_to semanticanswer_path(@semantic.id)
  end
  
  def show
    currentuser = User.find(session[:user_id])
    @semantic = Semanticnetwork.find(params[:id])

    if ( not (currentuser.role == "admin" or currentuser.student_id == @semantic.student_id) )
        redirect_to :root
    end

  end
  
  def result
     @student = Student.find(params[:id])

  end
  
  def destroy
  	Semanticnetwork.find(params[:id]).destroy
  	redirect_to :back
  end 
  
  
  def new
  end
  
  def updatesemanticjson
    @semantic = Semanticnetwork.find(params[:id])
  	@semantic.mistakes = ""
    @user = User.find (session["user_id"])
  	if (@user.role == 'admin' || (@user.role == 'student' && !@semantic.iscomplite))
  		@semantic.json = params[:json]
  			
      obj = @semantic.check_predicat(@semantic.json, @semantic.etalon.etalonjson)
		  result = obj[0]
      @semantic.mistakes = obj[1]
      @semantic.rating = result
      @semantic.iscomplite = true
	    @semantic.save()
      render text: @semantic.rating
    else
      render text: 'Вы уже выполнили моделирование данной ситуации'
		end
  end
  
  def getmistakes
  	@semantic = Semanticnetwork.find(params[:id])
  	render text: @semantic.mistakes
  end
end
