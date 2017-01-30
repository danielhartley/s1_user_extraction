require "s1_user_extraction/version"
require "s1_user_extraction/association"
require "s1_user_extraction/sql_builder/builder"
require "s1_user_extraction/sql_builder/belongs_to"
require 'pry-byebug'

module S1UserExtraction
  class App

    def initialize
      @associations = {}
    end

    def build_script(model)
      get_belongs_to(model).each do |assoc|
        @associations[assoc.get_class] ||= []
        @associations[assoc.get_class].push(SQLBuilder::BelongsTo.new(model.table_name, assoc.name+'_id', model.name))
      end

      get_has_many(model).each do |assoc|
        @associations[assoc.get_class] ||= []
        @associations[assoc.get_class].push(SQLBuilder::HasMany.new(assoc.table_name, model.name.downcase+'_id', model.name))
      end

      @associations
    end

    def get_has_many(model)
      model.reflect_on_all_associations(:has_many)#.map {|assoc| Association.new(assoc)}
    end

    def get_belongs_to(model)
      model.reflect_on_all_associations(:belongs_to).map {|assoc| Association.new(assoc)}
    end

    def get_has_one(model)
      model.reflect_on_all_associations(:has_one)#.map {|assoc| Association.new(assoc)}
    end

  end
end
