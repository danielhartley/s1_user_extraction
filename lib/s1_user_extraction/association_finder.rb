require_relative "association"
require_relative "sql_builder/builder"
require_relative "sql_builder/belongs_to"
require_relative "sql_builder/has_many"
require 'pry-byebug'

module S1UserExtraction
  class AssociationFinder

    def find_associations(model)
      associations = {}
      # binding.pry if model = AccountantsUk::RedeemedPromoCodeService
      get_belongs_to(model).each do |assoc|
        binding.pry if assoc.polymorphic?
        associations[assoc.get_class] ||= []
        associations[assoc.get_class].push(SQLBuilder::BelongsTo.new(model.table_name, assoc.name+'_id', model.name))
      end

      get_has_many(model).each do |assoc|
        associations[assoc.get_class] ||= []
        associations[assoc.get_class].push(SQLBuilder::HasMany.new(assoc.table_name, model.name.downcase+'_id', model.name))
      end

      associations
    end

    def get_has_many(model)
      model.reflect_on_all_associations(:has_many).map {|assoc| Association.new(assoc)}
    end

    def get_belongs_to(model)
      model.reflect_on_all_associations(:belongs_to).map {|assoc| Association.new(assoc)}
    end

    def get_has_one(model)
      model.reflect_on_all_associations(:has_one).map {|assoc| Association.new(assoc)}
    end

  end
end
