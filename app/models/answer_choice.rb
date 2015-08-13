class AnswerChoice < ActiveRecord::Base
  validates :question_id, presence: true
  validates :text, presence: true
end
