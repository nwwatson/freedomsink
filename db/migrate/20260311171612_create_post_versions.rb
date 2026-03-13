class CreatePostVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :post_versions do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :version_number, null: false
      t.string :title, null: false
      t.string :subtitle
      t.text :content_html
      t.text :body_plain

      t.timestamps
    end

    add_index :post_versions, [ :post_id, :version_number ], unique: true
  end
end
