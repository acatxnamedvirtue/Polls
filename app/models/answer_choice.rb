class AnswerChoice < ActiveRecord::Base
  validates :question_id, presence: true
  validates :text, presence: true

  belongs_to :question,
    class_name: "Question",
    foreign_key: :question_id,
    primary_key: :id

  has_many :responses, :dependent => :destroy,
    class_name: "Response",
    foreign_key: :answer_choice_id,
    primary_key: :id
end
