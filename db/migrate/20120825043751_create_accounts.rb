class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :fb_id

      t.timestamps
    end
  end
end
