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

end
