class CreateKaszas < ActiveRecord::Migration
  def change
    create_table :kaszas do |t|
      t.integer :account_id
      t.integer :picture_id

      t.timestamps
    end
  end
end
