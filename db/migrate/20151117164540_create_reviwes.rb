class CreateReviwes < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :comment
      t.references :user
      t.references :post
      t.timestamps
    end
  end
end
