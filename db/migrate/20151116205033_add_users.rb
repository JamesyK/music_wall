class AddUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
    end

    change_table :posts do |t|
      t.references :user
    end
  end
end
