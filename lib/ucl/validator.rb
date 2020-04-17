# frozen_string_literal: true

module UCL
  class Validator

    def validate(schema, string)
      schema = UCL::Parser.parse(schema)
      string = UCL::Parser.parse(string)
      do_validation(schema, string)
    end


    private


    def do_validation(schema, string)
      error = UCL::Wrapper::SchemaError.new
      UCL::Wrapper.object_validate(schema, string, error)
      raise UCL::Error::SchemaError, error.message if error.code != :UCL_SCHEMA_OK

      true
    end

  end
end
