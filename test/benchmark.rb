require_relative 'test_helper'
require 'benchmark/ips'

shop = Shop.create(name: 'shop')

1000.times do |i|
  category = shop.categories.create(name: "name-#{i}")
  10.times do |j|
    category.products.create(name: "name-#{i}-#{j}", price: i * 100, stock: j + 3*i)
  end
end


Benchmark.ips(:time => 1, :warmup => 1, :quiet => false) do |x|
  x.report("with preload_query") {
    shop.categories.preload_query(:sum_price).map(&:sum_price)
  }

  x.report("alternative method") {
    categories = shop.categories
    hash = Category.sum_price(categories.map(&:id)).map{|c| [c.id, c.sum_price]}.to_h
    categories.map{|c|
      hash[c.id]
    }
  }

  x.report("without preload") {
    shop.categories.map(&:sum_price2)
  }
end

