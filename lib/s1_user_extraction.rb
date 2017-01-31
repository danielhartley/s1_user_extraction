require "s1_user_extraction/version"
require "s1_user_extraction/association_finder"
require 'pry-byebug'

module S1UserExtraction
  class App

    def initialize
      @finder = S1UserExtraction::AssociationFinder.new
      @models_covered = [AsyncHandlerQueueItem]
    end

    def find_associations(models)
      current_associations = {}
      models.reject{|model| @models_covered.include? model}.each do |model|
        current_associations = merge_array_hash(current_associations, @finder.find_associations(model))
      end
      @models_covered = @models_covered | models
      if current_associations.keys.size > 0
        current_associations = merge_array_hash(current_associations, find_associations(current_associations.keys))
      end
      current_associations
    end

    def merge_array_hash(first_hash, second_hash)
      first_hash.merge(second_hash) { |key, oldval, newval| oldval | newval }
    end

  end
end
