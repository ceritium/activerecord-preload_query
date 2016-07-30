require 'active_support/lazy_load_hooks'
require "activerecord/preload_query/version"

ActiveSupport.on_load(:active_record) do

  class ActiveRecord::Associations::CollectionProxy
    delegate :preload_query, to: :scope
  end

  class ActiveRecord::Relation
    alias_method :origin_initialize, :initialize

    def initialize(*args)
      origin_initialize(*args)
      @preload_queries = []
    end

    def preload_query(*names)
      @preload_queries.push(*Array.wrap(names))
      self
    end

    private

    alias_method :origin_exec_queries, :exec_queries
    def exec_queries
      records = origin_exec_queries

      # added
      @preload_queries.each do |pc|
        _tmp = @klass.send(pc, records.map(&:id)).map{|x| [x.id, x.send(pc)]}.to_h
        records.map do |record|
          record.define_singleton_method pc, lambda { _tmp[record.id] }
        end
      end

      records
    end
  end
end
