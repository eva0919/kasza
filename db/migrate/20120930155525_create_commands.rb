class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.string :picture_id
      t.string :fb_id
      t.string :fb_name
      t.string :content

      t.timestamps
    end
  end
end
