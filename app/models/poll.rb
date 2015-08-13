class Poll < ActiveRecord::Base
  validates :author_id, presence: true
  validates :title, presence: true
end
