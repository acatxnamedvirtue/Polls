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
    # question.responses.where("CASE WHEN ? IS NOT NULL THEN responses.id != ? ELSE TRUE END", self.id, self.id)
    sql = <<-SQL
      SELECT
        responses.*
      FROM
        answer_choices AS ac1
      JOIN
        questions
        ON questions.id = ac1.question_id
      JOIN
        answer_choices AS ac2
        ON ac2.question_id = questions.id
      JOIN
        responses
        ON responses.answer_choice_id = ac2.id
      WHERE
        ac1.id = ?
        AND CASE WHEN ? IS NOT NULL THEN responses.id != ? ELSE TRUE END

        SELECT responses.*
        FROM "responses"
        INNER JOIN "answer_choices" ON "answer_choices"."id" = "responses"."answer_choice_id"
        INNER JOIN "questions" ON "questions"."id" = "answer_choices"."question_id"
        JOIN answer_choices AS ac1 ON questions.id = ac1.question_id
        JOIN answer_choices AS ac2 ON ac2.question_id = questions.id
        JOIN responses ON responses.answer_choice_id = ac2.id WHERE (ac1.id = 1 AND CASE WHEN 1 IS NOT NULL THEN responses.id != 1 ELSE TRUE END)

        SELECT "responses".*
          FROM "responses"
        INNER JOIN
          "answer_choices" ON "answer_choices"."id" = "responses"."answer_choice_id"
        INNER JOIN
          "questions" ON "questions"."id" = "answer_choices"."question_id"
        JOIN
          answer_choices AS ac1 ON questions.id = ac1.question_id
        JOIN
          answer_choices AS ac2 ON ac2.question_id = questions.id
        WHERE
          (ac1.id = 1 AND CASE WHEN 1 IS NOT NULL THEN responses.id != 1 ELSE TRUE END)

        SELECT
          "responses".*
        FROM
          "responses"
        INNER JOIN
          "answer_choices" ON "answer_choices"."id" = "responses"."answer_choice_id"
        INNER JOIN
          "questions" ON "questions"."id" = "answer_choices"."question_id"
        JOIN
          answer_choices AS ac1 ON questions.id = ac1.question_id
        WHERE
          (ac1.id = 1 AND CASE WHEN 1 IS NOT NULL THEN responses.id != 1 ELSE TRUE END)

    SQL

    results = Response
      .joins("JOIN answer_choices AS ac1 ON questions.id = ac1.question_id")
      .joins(:question)
      .where("ac1.id = ? AND CASE WHEN ? IS NOT NULL THEN responses.id != ? ELSE TRUE END", self.answer_choice_id, self.id, self.id)
      # .joins("JOIN answer_choices AS ac2 ON ac2.question_id = questions.id")
      # .joins("JOIN responses AS r1 ON r1.answer_choice_id = ac2.id")
      # .where("ac1.id = ? AND CASE WHEN ? IS NOT NULL THEN r1.id != ? ELSE TRUE END", self.answer_choice_id, self.id, self.id).distinct
  end

  private
  def respondent_has_not_already_answered_question
    if sibling_responses.any? {|response| response.user_id == self.user_id}
      errors[:user_id] << "has already answered this question."
    end
  end

  def author_cannot_respond_to_own_poll
    # sql = <<-SQL
    #   SELECT
    #     polls.author_id
    #   FROM
    #     answer_choices
    #   JOIN
    #     questions
    #     ON questions.id = answer_choices.question_id
    #   JOIN
    #     polls
    #     ON polls.id = questions.poll_id
    #   WHERE
    #     answer_choices.id = 5;
    # SQL

    result = Poll.select("polls.author_id")
              .joins(:questions)
              .joins("JOIN answer_choices ON questions.id = answer_choices.question_id")
              .where("answer_choices.id = #{self.answer_choice_id}")

    if result.first.author_id = self.user_id
      errors[:user_id] << "cannot respond to own poll."
    end
  end
end
