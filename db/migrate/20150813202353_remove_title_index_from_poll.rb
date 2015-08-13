class RemoveTitleIndexFromPoll < ActiveRecord::Migration
  def change
    remove_index :polls, :title
  end
end
