class Question < ActiveRecord::Base
  validates :poll_id, presence: true
  validates :text, presence: true

  has_many :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id

  belongs_to :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id

  has_many :responses,
    through: :answer_choices,
    source: :responses

  def results
<<<<<<< HEAD
=======
    # choices = answer_choices.includes(:responses)
    # result = {}
    # choices.each do |choice|
    #   result[choice.text] = choice.responses.count
    # end
    # result

    # sql = <<-SQL
    #   SELECT
    #     answer_choices.*, COUNT(responses.id) AS responses_count
    #   FROM
    #     answer_choices
    #   LEFT JOIN
    #     responses
    #     ON answer_choices.id = responses.answer_choice_id
    #   WHERE
    #     answer_choices.question_id = #{self.id}
    #   GROUP BY
    #     answer_choices.id
    # SQL

>>>>>>> 1bd1755ae074dfcf8c63767f707ade7fd3d9df54
    choices_with_counts = answer_choices
      .select('answer_choices.*, COUNT(responses.id) AS responses_count')
      .joins('LEFT JOIN responses ON answer_choices.id = responses.answer_choice_id')
      .group('answer_choices.id')

    choices_with_counts.map { |choice| [choice.text, choice.responses.count] }.to_h
  end
end
