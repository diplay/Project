#coding: utf-8
class SemanticanswersController < ActionController::Base

include PlanningHelper


  def index
  		@user = User.find (session["user_id"])
  		if (@user.role == "admin")
  			@tests = Semanticnetwork.all
	
  		else
  			redirect_to :root
  		end
  end

  def execute
    session["planning_task_id"] = params[:planning_task_id]
    create
  end
	
  def create 
    @semantic = Semanticnetwork.new()
    @semantic.rating = 0;
    @semantic.etalon = Etalon.where(:check => true).order("RANDOM()").first
    print ("-------------------")
    print (@semantic.etalon.to_json)

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
  			
  			result = 100
			mark = @semantic.check_predicat(@semantic.json, @semantic.etalon.etalonjson)
  			if mark > 0 
  				result -= mark
          			@semantic.mistakes += "Ошибка в предикатной вершине\n"
  			end
			
			if result > 0
				mark = @semantic.check_act(@semantic.json, @semantic.etalon.etalonjson)
				if mark > 0
					result -= mark
          				@semantic.mistakes += "Ошибки в Актантах\n"
				end	

				mark = @semantic.check_repetition(@semantic.json, @semantic.etalon.etalonjson)
				if mark > 0
					result -= mark
          				@semantic.mistakes += "Ошибки в Вершинах понятиях\n"
				end

				mark = @semantic.check_goodNodes(@semantic.json, @semantic.etalon.etalonjson)
				if mark > 0
					result -= mark
          				@semantic.mistakes += "Ошибки в Вершинах понятиях\n"
				end	
			end
  			
  			if (result > 0 && result < 20)
          @semantic.mistakes += "Очень плохой результат >:-("
  			end
  			if (result >= 20 && result < 40)
          @semantic.mistakes += "Плохой результат :("
  			end
  			if (result >= 40 && result <60)
          @semantic.mistakes += "не самый плохой результат :-| "
  			end
  			if ( result >= 60 && result < 80)
          @semantic.mistakes += "Хороший результат :) "
  			end
  			if ( result >= 80 && result < 100)
          @semantic.mistakes += "Отличный результат :3 "
  			end
  			if ( result == 100)
          @semantic.mistakes += "\m/ Отлично \m/ :3 "
  			end
  			
  			  			
  			if (result < 0 )
  				result = 0
  			end

  				@semantic.rating = result
  				@semantic.iscomplite = true
  				#@semantic.mistakes = mistakes
  				@semantic.save()
  		end
  		render text: @semantic.rating
  	
  end
  
  def getmistakes
  	@semantic = Semanticnetwork.find(params[:id])
  	render text: @semantic.mistakes
  end
end
