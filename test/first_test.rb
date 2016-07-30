require 'test_helper'

describe 'preload_query' do

  before do
    Product.delete_all
    Category.delete_all
    Shop.delete_all

    @shop = Shop.create(name: 'shop')

    2.times do |i|
      category = @shop.categories.create(name: "name-#{i}")
      2.times do |j|
        category.products.create(name: "name-#{i}-#{j}", price: i * 100, stock: j + 3*i)
      end
    end
  end

  it "preload_queries without relation" do
    categories = Category.all.preload_query(:sum_price)
    assert_equal [0, 200], categories.map(&:sum_price)
  end

  it "preload_queries with relation" do
    categories = @shop.categories.preload_query(:sum_price)
    assert_equal [0, 200], categories.map(&:sum_price)
  end

  it 'accept multiple items' do
    categories = Category.all.preload_query(:sum_price, :products_count)
    assert_equal [0, 200], categories.map(&:sum_price)
    assert_equal [2, 2], categories.map(&:products_count)
  end

  it 'allow chain methods' do
    categories = Category.all.preload_query(:sum_price).preload_query(:products_count)
    assert_equal [0, 200], categories.map(&:sum_price)
    assert_equal [2, 2], categories.map(&:products_count)
  end

  it 'compatible with limit' do
    categories = Category.all.preload_query(:sum_price, :products_count).limit(1)
    assert_equal [0], categories.map(&:sum_price)
    assert_equal [2], categories.map(&:products_count)
  end
end
