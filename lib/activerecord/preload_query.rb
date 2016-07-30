require "activerecord/preload_query/version"

ActiveSupport.on_load(:active_record) do

  class ActiveRecord::Associations::CollectionProxy
    delegate :preload_query, to: :scope
  end

  class ActiveRecord::Relation
    def initialize(klass, table, predicate_builder, values = {})
      @klass  = klass
      @table  = table
      @values = values
      @offsets = {}
      @loaded = false
      @predicate_builder = predicate_builder

      # added
      @preload_queries = []
    end

    def preload_query(*names)
      @preload_queries.push(*Array.wrap(names))
      self
    end

    private

    def exec_queries
      @records = eager_loading? ? find_with_associations.freeze : @klass.find_by_sql(arel, bound_attributes).freeze

      preload = preload_values
      preload +=  includes_values unless eager_loading?
      preloader = build_preloader
      preload.each do |associations|
        preloader.preload @records, associations
      end

      @records.each(&:readonly!) if readonly_value

      @loaded = true


      # added
      @preload_queries.each do |pc|
        _tmp = @klass.send(pc, records.map(&:id)).map{|x| [x.id, x.send(pc)]}.to_h
        @records.map do |record|
          record.define_singleton_method pc, lambda { _tmp[record.id] }
        end
      end

      @records
    end
  end
end
