module S1UserExtraction
  class Association < Struct.new(:association)
    delegate :foreign_key, to: :association

    def get_class
      return association.klass unless association.options[:classname]
      model_name.split('::').reject{|str| str.empty?}.inject(Object) do |mod, class_name|
        mod.const_get(class_name)
      end
    end

    def table_name
      association.table_name
    end

    def model_name
      association.options[:class_name] || association.name
    end

    def name
      association.name.to_s
    end

    def polymorphic?
      !!association.options[:polymorphic]
    end

    def polymorphic_dependencies
      return [] unless polymorphic?
      @polymorphic_dependencies ||= ActiveRecord::Base.subclasses.select { |model| polymorphic_match? model }
    end

    def polymorphic_match?(model)
      model.reflect_on_all_associations(:has_many).any? do |has_many_association|
        has_many_association.options[:as] == association.name
      end
    end

    def dependencies
      polymorphic? ? polymorphic_dependencies : Array(klass)
    end

    def polymorphic_type
      association.foreign_type if polymorphic?
    end
  end
end
