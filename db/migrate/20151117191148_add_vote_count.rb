class AddVoteCount < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.integer :votes_count
    end
  end
end
