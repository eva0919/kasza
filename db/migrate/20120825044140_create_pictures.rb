class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :image
      t.string :kind
      t.text :content
      t.string :latitude
      t.string :longitude
      t.string :tag

      t.timestamps
    end
  end
end
