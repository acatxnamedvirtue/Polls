class Response < ActiveRecord::Base
  validates :user_id, presence: true
  validates :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :author_cannot_respond_to_own_poll

  belongs_to :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_choice_id,
    primary_key: :id

  belongs_to :respondent,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_one :question,
    through: :answer_choice,
    source: :question

  def sibling_responses
    # question.responses.where("? IS NULL OR responses.id != ?", self.id, self.id)

    results = Response
      .joins(:question)
      .joins("JOIN answer_choices AS ac1 ON questions.id = ac1.question_id")
      .where("ac1.id = ? AND (? IS NULL OR responses.id != ?)", self.answer_choice_id, self.id, self.id)
  end

  private
  def respondent_has_not_already_answered_question
    if sibling_responses.any? {|response| response.user_id == self.user_id}
      errors[:user_id] << "has already answered this question."
    end
  end

  def author_cannot_respond_to_own_poll
    result = Poll.select("polls.author_id")
              .joins(:questions)
              .joins("JOIN answer_choices ON questions.id = answer_choices.question_id")
              .where("answer_choices.id = ?", self.answer_choice_id)

    if result.first.author_id == self.user_id
      errors[:user_id] << "cannot respond to own poll."
    end
  end
end
