#coding: utf-8
class GroupsController < AdminToolsController
  include PlanningHelper

  def self.create_extension
    ext = ExtensionDatabase::ATExtension.new
    ext.ext_type = ExtensionDatabase::ExtensionType::Other
    ext.description = "Компонент добавления групп"
    ext.tasks = ["group-config-step"]

    ext.generate_state = lambda { |mode_id, week_id, schedule, state|
      atom = StateFacts.create(
          task_name: "group-config-step",
          state: 1)
      state.atoms.push << atom
    }

    ext.task_description = lambda { |leaf_id|
      return "Добавление групп"
    }

    ext.task_exec_path = lambda { |pddl_act, leaf_id|
      if((pddl_act == "execute-development-step") && (leaf_id == "group-config-step"))
        return {"controller" => "groups", "params" => {}}
      else
        return {}
      end
    }

    return ext
  end

  def index

    if (session[:planning_task_id]!=nil)
      @task = PlanningTask.find(session[:planning_task_id])
    end
    @groups = []
    Group.find_each do |group|
      @groups << {"number" => group.number,
                  "show_ref" => "<a href=\"#{group_path(group)}\">Просмотр</a>",
                  "edit_ref" => "<a href=\"#{edit_group_path(group)}\">Редактировать</a>"}
    end
  end

  def show
    @group = Group.find(params[:id])
    @students = []
    Student.where(group: @group).each do |student|
      @students << {"fio" => "<a href=\"#{group_student_path(@group, student)}\">#{student.fio}</a>",
                    "login" => student.user.login}
    end
  end

  def new
  end

  def generate_report
    @group = Group.find(params[:id])
    @date = (params[:date] || [""]).last.to_date
    @date ||= Date.today
    @results = []
    @group.students.each do |student|
      cur_res = student.results.where("updated_at >= ? AND updated_at <= ?",
                                      @date.beginning_of_day,
                                      @date.end_of_day).last
      if cur_res == nil
        @results << {"fio" => student.fio,
                     "G" => "-",
                     "V" => "-",
                     "S" => "-",
                     "avr" => 0}
      else
        @results << {"fio" => "<a href=\"#{group_student_path(@group, student)}\">" +
          student.fio + "</a>",
                    "G" => cur_res.g_result.mark,
                    "V" => cur_res.v_result.mark,
                    "S" => cur_res.s_result.mark,
                    "avr" => cur_res.mark}
      end
    end
  end

  def generate_pass
    group = Group.find(params[:id])
    ans = "<style>td{border: 1px solid; padding: 5px;}</style>"
    ans << "Группа #{group.number}<br/>"
    ans << "<table style='border-collapse: collapse; font-family: sans-serif;' ><tr><th>ФИО</th><th>Логин</th><th>Пароль</th></tr>"
    group.students.each do |student|
      pass = rand(36**10).to_s(36)
      ans << "<tr><td>#{student.fio}</td><td>#{student.user.login}</td><td>#{pass}</td></tr>"
      student.user.pass = Digest::MD5.hexdigest(pass)
      student.user.save
    end
    ans << "</table>"
    render text: ans#, content_type: "text/html; charset=utf-8"
  end

  def create
    group = Group.create(number: params[:number])
    group.create_timetable
    redirect_to edit_group_path(group)
  end

  def edit
    @group = Group.find(params[:id])
    @students = []
    Student.where(group: @group).each do |student|
      @students << {"fio" => student.fio,
                    "login" => student.user.login,
                    "delete" => "<a data-method=\"delete\" href=\"#{group_student_path(@group, student)}\">Удалить</a>"}
    end
    @students << {"fio" =>'<input type="textbox" name="fio" placeholder="ФИО" />',
      "login" => '<input type="submit" value="Добавить">',
      "delete" => ""}
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
    group = Group.find(params[:id])
    group.number = params[:number]
    group.save
    redirect_to groups_path(group)
  end

  def statements
    group = Group.find(params[:id])
    $g = group
    $students = []
    $all_tests = []
    Student.where(group: group).each do |student|
      s = {
        "fio" => student.fio,
        "group" => group.number,
        "id" => student.id
      }
      test_results = KaResult.where(user_id: student.user.id).order(created_at: :desc)
      problem_areas = []
      tests = []
      areas_done = false
      test_results.each do |res|
        tests.prepend({
          "test_id" => res.ka_test.id,
          "text" => res.ka_test.text,
          "mark" => res.assessment
        })
        if $all_tests.find {|t| t["test_id"] == res.ka_test.id} == nil
          $all_tests.prepend({
            "test_id" => res.ka_test.id,
            "text" => res.ka_test.text,
          })
        end  
        res.problem_areas.each do |p|
          area = problem_areas.find {|pa| pa["topic_id"] == p.ka_topic.id}
          if area == nil
            if areas_done == false
              problem_areas << {
                "topic_id" => p.ka_topic.id,
                "text" => p.ka_topic.text,
                "mark" => p.mark.round(2)
              }
            end
          else
            if area["mark"] < p.mark
              index = problem_areas.find_index(area)
              problem_areas[index]["mark"] = p.mark
            end
          end
        end
        areas_done = true
      end
      s["tests"] = tests
      s["problem_areas"] = problem_areas

      # Поиск оценок по П/О выводу

      f_results = Fbresult.where(fio: student.fio, group: student.group.number, fb: "Прямой").order(result: :desc)
      if f_results.count != 0
        s["forward"] = f_results[0].result
      else
        s["forward"] = "-"
      end

      b_results = Fbresult.where(fio: student.fio, group: student.group.number, fb: "Обратный").order(result: :desc)
      if b_results.count != 0
        s["backward"] = b_results[0].result
      else
        s["backward"] = "-"
      end

      # Поиск оценок по семантическим сетям и фреймам

      semantic_results = Semanticnetwork.where(student_id: student.id).order(rating: :desc)
      if semantic_results.count != 0
        s["semantics"] = semantic_results[0].rating
      else
        s["semantics"] = "-"
      end

      frame_results = Studentframe.where(student_id: student.id).order(result: :desc)
      if frame_results.count != 0
        s["frames"] = frame_results[0].result.to_i
      else
        s["frames"] = "-"
      end

      $students << s
    end
    render :statements
  end

end
