class User < ActiveRecord::Base
  validates :user_name, uniqueness: true, presence: true

  has_many :authored_polls,
    class_name: 'Poll',
    foreign_key: :author_id,
    primary_key: :id

  has_many :responses,
    class_name: "Response",
    foreign_key: :user_id,
    primary_key: :id

  def completed_polls
    get_polls.having("COUNT(questions.id) = COUNT(user_responses)")
  end

  def uncompleted_polls
    get_polls.having("COUNT(questions.id) != COUNT(user_responses)")
  end

  private
  def get_polls
    Poll
      .joins(:questions)
      .joins("JOIN answer_choices ON questions.id = answer_choices.question_id")
      .joins("LEFT JOIN (SELECT responses.* FROM responses WHERE responses.user_id = ?) AS user_responses ON answer_choices.id = user_responses.answer_choice_id", self.id)
      .group("polls.id")
      .having("COUNT(questions.id) = COUNT(user_responses)")
  end
end
