require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'active_record'
require 'activerecord/preload_query'
require 'pry'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table "categories", id: false do |t|
    t.string "sku", primary: true
    t.string   "name"
    t.integer  "shop_id"
  end

  create_table "products" do |t|
    t.string   "name"
    t.string  "category_id"
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
  self.primary_key = 'sku'

  belongs_to :shop
  has_many :products

  class << self

    def _products_count(ids)
      where(sku: ids).group("categories.sku").joins(:products).select("categories.sku, count(products.id) AS _products_count")
    end

    def _sum_price(ids)
      where(sku: ids).group("categories.sku").joins(:products).select("categories.sku, sum(products.price) AS _sum_price")
    end
  end

  def products_count
    products.count
  end

  def sum_price
    products.sum(:price)
  end
end

class Product < ActiveRecord::Base
  belongs_to :category
end
