class Event < ActiveRecord::Base
  belongs_to :timetable

	def current_week
	    a = Date.today.beginning_of_week
	    begin_autumn = Date.today.change(:month => 9, :day => 1).beginning_of_week
            begin_spring = Date.today.change(:month => 2, :day => 9).beginning_of_week
            week = 0
           
            if (a > begin_autumn) or (a == begin_autumn)  
	    	week += 1
                while a > begin_autumn do
			a = a.weeks_ago(1)
			week += 1
	    	end
                return week
            end
            if ((a > begin_spring) or (a == begin_spring)) and (a < begin_autumn) 
                week += 1
                while a > begin_spring do
			a = a.weeks_ago(1)
			week += 1
	    	end
            end
            return week
	end
end
