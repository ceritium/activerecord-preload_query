require 'test_helper'

describe 'preload_query' do

  before do
    Product.delete_all
    Category.delete_all
    Shop.delete_all

    @shop = Shop.create(name: 'shop')


    2.times do |i|
      category = @shop.categories.create(name: "name-#{i}", sku: "sku#{i}")
      (i+2).times do |j|
        category.products.create(name: "name-#{i}-#{j}", price: i * 100, stock: j + 3*i)
      end
    end
  end

  it 'do not break models without primary_key' do
    assert_equal Tag.all, []
  end

  it 'test expected values' do
    scope = Category.all
    preload = scope.preload_query(:_sum_price, :_products_count)
    assert_equal [0, 300], preload.map(&:_sum_price)
    assert_equal [2, 3], preload.map(&:_products_count)

    assert_equal [0, 300], scope.map(&:sum_price)
    assert_equal [2, 3], scope.map(&:products_count)
  end

  it 'preload_queries without relation' do
    scope = Category.all
    preload = scope.preload_query(:_sum_price)
    assert_equal scope.map(&:sum_price), preload.map(&:_sum_price)
  end

  it 'preload_queries with relation' do
    scope = @shop.categories
    preload = scope.preload_query(:_sum_price)
    assert_equal scope.map(&:sum_price), preload.map(&:_sum_price)
  end

  it 'accept multiple items' do
    scope = Category.all
    preload = scope.preload_query(:_sum_price, :_products_count)
    assert_equal scope.map(&:sum_price), preload.map(&:_sum_price)
    assert_equal scope.map(&:products_count), preload.map(&:_products_count)
  end

  it 'allow chain methods' do
    scope = Category.all
    preload = scope.preload_query(:_sum_price).preload_query(:_products_count)
    assert_equal scope.map(&:sum_price), preload.map(&:_sum_price)
    assert_equal scope.map(&:products_count), preload.map(&:_products_count)
  end

  it 'model respond to preload_query' do
    preload = Category.preload_query(:_sum_price)
    assert_equal Category.all.map(&:sum_price), preload.map(&:_sum_price)
  end

end
