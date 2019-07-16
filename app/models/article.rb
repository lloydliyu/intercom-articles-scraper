class Article < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :body
  validates_presence_of :page_slug
  validates_presence_of :language
  validates_uniqueness_of :title
  validates_uniqueness_of :page_slug
end
