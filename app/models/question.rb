class Question < ActiveRecord::Base
  validates :poll_id, presence: true
  validates :text, presence: true

  has_many :answer_choices, :dependent => :destroy,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id

  belongs_to :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id

  has_many :responses, :dependent => :destroy,
    through: :answer_choices,
    source: :responses

  def results
    choices_with_counts = answer_choices
      .select('answer_choices.*, COUNT(responses.id) AS responses_count')
      .joins('LEFT JOIN responses ON answer_choices.id = responses.answer_choice_id')
      .group('answer_choices.id')

    choices_with_counts.map { |choice| [choice.text, choice.responses.count] }.to_h
  end
end
