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
    decoder = Decoder.new
    decoder.decode(string)
  end


  def self.dump(object, emit_type = Encoder::DEFAULT_EMITTER)
    encoder = Encoder.new
    encoder.encode(object, emit_type)
  end


  def self.validate(schema, string)
    validator = Validator.new
    validator.validate(schema, string)
  end


  def self.valid?(schema, string)
    validate(schema, string)
  rescue UCL::Error::SchemaError
    false
  end

end
