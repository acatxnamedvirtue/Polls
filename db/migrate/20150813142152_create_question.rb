class CreateQuestion < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :poll_id
      t.text :text
    end

    add_index  :questions, :poll_id
  end
end
