class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :category
      t.string :section
      t.string :page_slug
      t.string :language
      t.text :body
      t.timestamps
    end
  end
end
