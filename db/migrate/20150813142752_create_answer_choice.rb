class CreateAnswerChoice < ActiveRecord::Migration
  def change
    create_table :answer_choices do |t|
      t.integer :question_id
      t.text :text
    end

    add_index :answer_choices, :question_id
  end
end
