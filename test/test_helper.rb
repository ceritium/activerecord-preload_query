require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'active_record'
require 'activerecord/preload_query'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table "categories" do |t|
    t.string   "name"
    t.integer  "shop_id"
  end

  create_table "products" do |t|
    t.string   "name"
    t.integer  "category_id"
    t.integer  "price"
    t.integer  "stock"
  end

  create_table "shops" do |t|
    t.string   "name"
  end
end

class Shop < ActiveRecord::Base
  has_many :categories
end

class Category < ActiveRecord::Base
  belongs_to :shop
  has_many :products

  class << self

    def products_count(ids)
      where(id: ids).group("categories.id").joins(:products).select("categories.id, count(products.id) AS products_count")
    end

    def sum_price(ids)
      where(id: ids).group("categories.id").joins(:products).select("categories.id, sum(products.price) AS sum_price")
    end

  end
end

class Product < ActiveRecord::Base
  belongs_to :category
end
