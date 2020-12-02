# frozen_string_literal: true

require 'ffi'

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  'ucl' => 'UCL'
)
loader.setup

module UCL

  def self.load(string)
    Decoder.decode(string)
  end


  def self.dump(object, emit_type = Encoder::DEFAULT_EMITTER)
    Encoder.encode(object, emit_type)
  end


  def self.validate(schema, string)
    Validator.validate(schema, string)
  end


  def self.valid?(schema, string)
    validate(schema, string)
  rescue UCL::Error::SchemaError
    false
  end

end
