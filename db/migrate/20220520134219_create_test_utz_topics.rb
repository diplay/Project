class CreateTestUtzTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :test_utz_topics do |t|
      t.integer :weight
      t.references :test_utz_question, foreign_key: true
      t.references :ka_topic, foreign_key: true

      t.timestamps
    end
  end
end
