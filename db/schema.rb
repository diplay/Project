# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20220520134219) do

  create_table "bnfs", force: :cascade do |t|
    t.integer "component_id"
    t.string  "component_type", limit: 255
    t.text    "bnf_json"
    t.index ["component_id", "component_type"], name: "index_bnfs_on_component_id_and_component_type"
  end

  create_table "competence_coverages", id: false, force: :cascade do |t|
    t.integer  "ka_result_id"
    t.integer  "competence_id"
    t.float    "mark",          default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["competence_id"], name: "index_competence_coverages_on_competence_id"
    t.index ["ka_result_id"], name: "index_competence_coverages_on_ka_result_id"
  end

  create_table "competences", force: :cascade do |t|
    t.string   "code",        limit: 255, default: "", null: false
    t.string   "description", limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "component_element_topics", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "component_elements_id"
    t.integer  "ka_topics_id"
    t.index ["component_elements_id"], name: "index_component_element_topics_on_component_elements_id"
    t.index ["ka_topics_id"], name: "index_component_element_topics_on_ka_topics_id"
  end

  create_table "component_elements", force: :cascade do |t|
    t.string   "tag"
    t.text     "desc"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "components_id"
    t.integer  "component_elements_id"
    t.boolean  "is_multiple",           default: false
    t.integer  "size"
    t.string   "name",                  default: ""
    t.index ["component_elements_id"], name: "index_component_elements_on_component_elements_id"
    t.index ["components_id"], name: "index_component_elements_on_components_id"
  end

  create_table "component_services", force: :cascade do |t|
    t.string   "name"
    t.integer  "actor"
    t.string   "path"
    t.integer  "component_id"
    t.boolean  "need_to_graduate"
    t.integer  "priority"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["component_id"], name: "index_component_services_on_component_id"
  end

  create_table "components", force: :cascade do |t|
    t.string "name"
    t.text   "additional", default: "{}"
  end

  create_table "constructs", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "etalonframes", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "dictionary"
    t.text     "studentcode"
    t.text     "framecode"
    t.text     "result"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "mistakes"
    t.text     "kbmistakes"
    t.text     "stdecription"
    t.boolean  "isuse"
  end

  create_table "etalons", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "etalonjson"
    t.text     "nodejson"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "check"
    t.integer  "ka_topic_id"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.date     "date"
    t.integer  "timetable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "action",       limit: 255
    t.string   "task",         limit: 255
    t.datetime "only_time"
    t.index ["timetable_id"], name: "index_events_on_timetable_id"
  end

  create_table "extension_databases", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fbresults", force: :cascade do |t|
    t.text     "group"
    t.string   "fio",        limit: 255
    t.string   "fb",         limit: 255
    t.integer  "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filling_utz_answers", force: :cascade do |t|
    t.string   "text",                    limit: 255
    t.integer  "filling_utz_interval_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["filling_utz_interval_id"], name: "index_filling_utz_answers_on_filling_utz_interval_id"
  end

  create_table "filling_utz_intervals", force: :cascade do |t|
    t.integer  "start"
    t.integer  "end"
    t.string   "answer",         limit: 255
    t.integer  "filling_utz_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "filling_utzs", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "hint"
    t.integer  "level"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "text"
    t.integer  "ka_topic_id"
    t.index ["ka_topic_id"], name: "index_filling_utzs_on_ka_topic_id"
  end

  create_table "frame_solvers", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "framedbs", force: :cascade do |t|
    t.text     "code"
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "frameobjectmistakes", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "frameobjects", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "frames", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "framesmistakes", force: :cascade do |t|
    t.text     "mistakes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "g_answers", force: :cascade do |t|
    t.text    "answer"
    t.integer "task_id"
    t.index ["task_id"], name: "index_g_answers_on_task_id"
  end

  create_table "g_results", force: :cascade do |t|
    t.integer "result_id"
    t.text    "answer"
    t.integer "mark"
    t.index ["result_id"], name: "index_g_results_on_result_id"
  end

  create_table "groups", force: :cascade do |t|
    t.text "number"
  end

  create_table "images_sort_utz_pictures", force: :cascade do |t|
    t.text     "src"
    t.integer  "ordering"
    t.integer  "images_sort_utz_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["images_sort_utz_id"], name: "index_images_sort_utz_pictures_on_images_sort_utz_id"
  end

  create_table "images_sort_utzs", force: :cascade do |t|
    t.text     "goal"
    t.text     "theme"
    t.string   "hint",        limit: 255
    t.integer  "level"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "ka_topic_id"
    t.index ["ka_topic_id"], name: "index_images_sort_utzs_on_ka_topic_id"
  end

  create_table "ka_answer_logs", force: :cascade do |t|
    t.integer  "ka_result_id"
    t.integer  "ka_answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ka_answers", force: :cascade do |t|
    t.text     "text",           default: "", null: false
    t.integer  "correct",        default: 0,  null: false
    t.integer  "ka_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["ka_question_id"], name: "index_ka_answers_on_ka_question_id"
  end

  create_table "ka_questions", force: :cascade do |t|
    t.text     "text",        default: "", null: false
    t.integer  "difficulty",  default: 0,  null: false
    t.integer  "ka_topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "disable",     default: 0,  null: false
    t.index ["ka_topic_id"], name: "index_ka_questions_on_ka_topic_id"
  end

  create_table "ka_questions_variants", id: false, force: :cascade do |t|
    t.integer  "ka_variant_id"
    t.integer  "ka_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["ka_variant_id", "ka_question_id"], name: "ka_q_ka_v", unique: true
  end

  create_table "ka_results", force: :cascade do |t|
    t.integer  "ka_variant_id"
    t.integer  "ka_test_id"
    t.integer  "user_id"
    t.integer  "assessment",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["ka_test_id"], name: "index_ka_results_on_ka_test_id"
  end

  create_table "ka_tests", force: :cascade do |t|
    t.text     "text",                        null: false
    t.integer  "on",              default: 0, null: false
    t.integer  "variants_count",  default: 0, null: false
    t.integer  "questions_count", default: 0, null: false
    t.integer  "minutes",         default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ka_topics", force: :cascade do |t|
    t.string   "text",       limit: 255, default: "", null: false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ontology"
    t.index ["parent_id"], name: "index_ka_topics_on_parent_id"
  end

  create_table "ka_variants", force: :cascade do |t|
    t.integer  "ka_test_id"
    t.integer  "number",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["ka_test_id", "number"], name: "index_ka_variants_on_ka_test_id_and_number"
  end

  create_table "logs", force: :cascade do |t|
    t.text    "mistakes"
    t.text    "data"
    t.integer "component_id"
    t.string  "component_type", limit: 255
    t.index ["component_id", "component_type"], name: "index_logs_on_component_id_and_component_type"
  end

  create_table "matching_utz_answers", force: :cascade do |t|
    t.text     "text"
    t.integer  "matching_utz_question_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "matching_utz_questions", force: :cascade do |t|
    t.text     "text"
    t.integer  "matching_utz_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "matching_utzs", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "hint"
    t.integer  "level"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "ka_topic_id"
    t.index ["ka_topic_id"], name: "index_matching_utzs_on_ka_topic_id"
  end

  create_table "methodical_materials", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "title",            limit: 255
    t.text     "description"
    t.text     "theoretical_part"
    t.text     "practical_part"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personalities", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.text     "description"
    t.integer  "personality_trait_id"
    t.float    "begin_at",                         default: 0.0
    t.float    "end_at",                           default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personalities_students", id: false, force: :cascade do |t|
    t.integer "personality_id", null: false
    t.integer "student_id",     null: false
  end

  create_table "personality_test_answer_pictures", force: :cascade do |t|
    t.string   "image_uid",                  limit: 255
    t.integer  "personality_test_answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personality_test_answer_weights", force: :cascade do |t|
    t.float    "value"
    t.integer  "personality_test_answer_id"
    t.integer  "personality_trait_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["personality_trait_id"], name: "index_personality_test_answer_weights_on_personality_trait_id"
  end

  create_table "personality_test_answers", force: :cascade do |t|
    t.text     "value"
    t.integer  "personality_test_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personality_test_question_pictures", force: :cascade do |t|
    t.string   "image_uid",                    limit: 255
    t.integer  "personality_test_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personality_test_question_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personality_test_questions", force: :cascade do |t|
    t.text     "value"
    t.integer  "personality_test_question_type_id"
    t.integer  "personality_test_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ordering"
    t.index ["personality_test_id"], name: "index_personality_test_questions_on_personality_test_id"
  end

  create_table "personality_test_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personality_tests", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.integer  "personality_test_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personality_tests_students", id: false, force: :cascade do |t|
    t.integer "personality_test_id", null: false
    t.integer "student_id",          null: false
  end

  create_table "personality_trait_intervals", force: :cascade do |t|
    t.float    "begin_at"
    t.float    "end_at"
    t.integer  "personality_id"
    t.integer  "personality_trait_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["personality_id"], name: "index_personality_trait_intervals_on_personality_id"
    t.index ["personality_trait_id"], name: "index_personality_trait_intervals_on_personality_trait_id"
  end

  create_table "personality_traits", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planner_events", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "type_id"
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planning_sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "closed",                 default: 0
    t.string   "plan",       limit: 255
    t.string   "procedure",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planning_states", force: :cascade do |t|
    t.integer  "planning_session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planning_tasks", force: :cascade do |t|
    t.integer  "planning_session_id"
    t.integer  "closed",                          default: 0
    t.string   "executor",            limit: 255
    t.string   "result",              limit: 255
    t.string   "action",              limit: 255
    t.string   "description",         limit: 255
    t.string   "params",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state_atom_id"
    t.index ["state_atom_id"], name: "index_planning_tasks_on_state_atom_id"
  end

  create_table "problem_areas", id: false, force: :cascade do |t|
    t.integer  "ka_result_id"
    t.integer  "ka_topic_id"
    t.float    "mark",         default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["ka_result_id"], name: "index_problem_areas_on_ka_result_id"
    t.index ["ka_topic_id"], name: "index_problem_areas_on_ka_topic_id"
  end

  create_table "recomendations", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "rec_id"
    t.text     "rec_type"
    t.datetime "date"
    t.boolean  "done"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "rec_status"
    t.text     "type_um"
    t.text     "data",       default: "{}"
    t.index ["student_id"], name: "index_recomendations_on_student_id"
  end

  create_table "results", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "results_mask"
    t.index ["student_id"], name: "index_results_on_student_id"
    t.index ["task_id"], name: "index_results_on_task_id"
  end

  create_table "s_answers", force: :cascade do |t|
    t.integer "task_id"
    t.text    "answer"
    t.index ["task_id"], name: "index_s_answers_on_task_id"
  end

  create_table "s_results", force: :cascade do |t|
    t.integer "result_id"
    t.integer "mark"
    t.text    "answer"
    t.index ["result_id"], name: "index_s_results_on_result_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.string   "group",      limit: 255
    t.integer  "psyho"
    t.integer  "knowledge1"
    t.integer  "knowledge2"
    t.integer  "frame_sem"
    t.integer  "vivod"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "semantic_nodes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "semanticnetworks", force: :cascade do |t|
    t.integer  "etalon_id"
    t.integer  "student_id"
    t.text     "json"
    t.text     "mistakes",          default: " Вы еще не прошли тест :) "
    t.boolean  "iscomplite",        default: false
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ka_topic_id"
    t.text     "recommendation_id"
    t.index ["etalon_id"], name: "index_semanticnetworks_on_etalon_id"
    t.index ["student_id"], name: "index_semanticnetworks_on_student_id"
  end

  create_table "state_base_atoms", force: :cascade do |t|
    t.string   "type",              limit: 255
    t.integer  "state"
    t.string   "task_name",         limit: 255
    t.integer  "planning_state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["planning_state_id"], name: "index_state_base_atoms_on_planning_state_id"
  end

  create_table "studentframes", force: :cascade do |t|
    t.integer  "etalonframe_id"
    t.integer  "student_id"
    t.text     "studentcode"
    t.text     "result"
    t.boolean  "isfinish"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "mistakes"
    t.text     "studentmistakes"
    t.text     "kbstudentmistakes"
    t.index ["etalonframe_id"], name: "index_studentframes_on_etalonframe_id"
    t.index ["student_id"], name: "index_studentframes_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.text    "fio"
    t.integer "group_id"
    t.index ["group_id"], name: "index_students_on_group_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.text "sentence1"
    t.text "sentence2"
    t.text "sentence3"
  end

  create_table "test_utz_answers", force: :cascade do |t|
    t.text     "text"
    t.boolean  "is_correct"
    t.integer  "test_utz_question_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["test_utz_question_id"], name: "index_test_utz_answers_on_test_utz_question_id"
  end

  create_table "test_utz_questions", force: :cascade do |t|
    t.text     "text"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "ka_topic_id"
    t.index ["ka_topic_id"], name: "index_test_utz_questions_on_ka_topic_id"
  end

  create_table "test_utz_topics", force: :cascade do |t|
    t.integer  "weight"
    t.integer  "test_utz_question_id"
    t.integer  "ka_topic_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["ka_topic_id"], name: "index_test_utz_topics_on_ka_topic_id"
    t.index ["test_utz_question_id"], name: "index_test_utz_topics_on_test_utz_question_id"
  end

  create_table "text_correction_utzs", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.text     "text_with_errors"
    t.text     "text_without_errors"
    t.integer  "errors_count"
    t.string   "hint",                limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "ka_topic_id"
    t.index ["ka_topic_id"], name: "index_text_correction_utzs_on_ka_topic_id"
  end

  create_table "timetable_templates", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "json"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timetables", force: :cascade do |t|
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "group_number"
    t.index ["group_id"], name: "index_timetables_on_group_id"
  end

  create_table "tokenlines", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topic_competences", id: false, force: :cascade do |t|
    t.integer  "ka_topic_id"
    t.integer  "competence_id"
    t.integer  "weight",        default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["competence_id"], name: "index_topic_competences_on_competence_id"
    t.index ["ka_topic_id"], name: "index_topic_competences_on_ka_topic_id"
  end

  create_table "topic_components", force: :cascade do |t|
    t.integer "ka_topic_id"
    t.integer "component_id"
    t.float   "weight",       default: 0.0, null: false
  end

  create_table "topic_constructs", id: false, force: :cascade do |t|
    t.integer  "ka_topic_id"
    t.integer  "construct_id"
    t.integer  "mark",         default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["construct_id"], name: "index_topic_constructs_on_construct_id"
    t.index ["ka_topic_id"], name: "index_topic_constructs_on_ka_topic_id"
  end

  create_table "topic_relations", id: false, force: :cascade do |t|
    t.integer  "ka_topic_id"
    t.integer  "related_topic_id"
    t.integer  "rel_type",         default: 2, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["ka_topic_id"], name: "index_topic_relations_on_ka_topic_id"
    t.index ["related_topic_id"], name: "index_topic_relations_on_related_topic_id"
  end

  create_table "trees", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "login",      limit: 255
    t.string   "pass",       limit: 255
    t.string   "role",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id"
    t.index ["student_id"], name: "index_users_on_student_id"
  end

  create_table "v_answers", force: :cascade do |t|
    t.integer "task_id"
    t.index ["task_id"], name: "index_v_answers_on_task_id"
  end

  create_table "v_results", force: :cascade do |t|
    t.integer "result_id"
    t.integer "mark"
    t.index ["result_id"], name: "index_v_results_on_result_id"
  end

end
