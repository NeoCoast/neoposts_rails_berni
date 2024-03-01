class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.datetime :published_at, null: false
      t.references :user

      t.timestamps
    end
  end
end
