# frozen_string_literal: true

module UCL
  class Validator

    def self.validate(schema, string)
      schema = UCL::Parser.parse(schema)
      string = UCL::Parser.parse(string)
      do_validation(schema, string)
    end


    def self.do_validation(schema, string) # rubocop:disable Naming/PredicateMethod
      error = UCL::Wrapper::SchemaError.new
      UCL::Wrapper.object_validate(schema, string, error)
      raise UCL::Error::SchemaError, error.message if error.code != :UCL_SCHEMA_OK

      true
    end
    private_class_method :do_validation

  end
end
