class Question < ActiveRecord::Base
  validates :poll_id, presence: true
  validates :text, presence: true
end
