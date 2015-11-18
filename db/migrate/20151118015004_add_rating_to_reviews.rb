class AddRatingToReviews < ActiveRecord::Migration
  def change
    change_table :reviews do |t|
      t.integer :rating
    end
  end
end
