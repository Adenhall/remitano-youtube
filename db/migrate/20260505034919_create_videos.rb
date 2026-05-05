class CreateVideos < ActiveRecord::Migration[8.1]
  def change
    create_table :videos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :youtube_url, null: false
      t.string :youtube_id, null: false
      t.string :title, null: false

      t.timestamps
    end
  end
end
