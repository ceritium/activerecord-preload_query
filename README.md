# Activerecord::PreloadQuery

[![Gem Version](https://badge.fury.io/rb/activerecord-preload_query.svg)](https://badge.fury.io/rb/activerecord-preload_query)
[![Build Status](https://travis-ci.org/ceritium/activerecord-preload_query.svg?branch=master)](https://travis-ci.org/ceritium/activerecord-preload_query)
[![Code Climate](https://codeclimate.com/github/ceritium/activerecord-preload_query/badges/gpa.svg)](https://codeclimate.com/github/ceritium/activerecord-preload_query)


PreloadQuery allows you to preload queries and have them available as the relations when use the `preload` method of ActiveRecord.

For example, given `Category` and `Product` classes and a method that adds the products' prices in a category, like `self.sum_price`:

```ruby
class Category < ActiveRecord::Base
  has_many :products

  class << self
    def sum_price(ids)
      where(id: ids).group("categories.id").joins(:products).select("categories.id, sum(products.price) AS sum_price")
    end
  end
end

class Product < ActiveRecord::Base
  belongs_to :category
end
```

we can write:

```ruby
Category.limit(10).preload_query(:sum_price).each do |category|
  p category.name
  p category.sum_price
end
```

The method to be preloaded must return an enumerable. Each element must respond to the primary_key of the class and the same method name.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-preload_query'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-preload_query

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ceritium/activerecord-preload_query. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

