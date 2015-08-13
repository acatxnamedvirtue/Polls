# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# users = User.create!([{user_name: "Tyler"}, {user_name: "Arthur"}])
# polls = Poll.create!([{title: "Poll1", author_id: 1}, {title: "Poll2", author_id: 2}])
questions = Question.create!([{poll_id: 1, text: "Question1"},
                             {poll_id: 1, text: "Question2"},
                             {poll_id: 2, text: "Question3"},
                             {poll_id: 2, text: "Question4"}
                             ])
answer_choices = AnswerChoice.create!([{question_id: 1, text: "AnswerChoice1"},
                                      {question_id: 2, text: "AnswerChoice2"},
                                      {question_id: 3, text: "AnswerChoice3"},
                                      {question_id: 4, text: "AnswerChoice4"}
                                      ])
responses = Response.create!([{user_id: 1, answer_choice_id: 1},
                              {user_id: 1, answer_choice_id: 2},
                              {user_id: 1, answer_choice_id: 3},
                              {user_id: 1, answer_choice_id: 4},
                              {user_id: 2, answer_choice_id: 1},
                              {user_id: 2, answer_choice_id: 2},
                              {user_id: 2, answer_choice_id: 3},
                              {user_id: 2, answer_choice_id: 4}
                            ])
