# frozen_string_literal: true

module UCL
  module Error
    class BaseError       < StandardError; end
    class DecoderError    < BaseError; end
    class ConversionError < BaseError; end
    class TypeError       < BaseError; end
    class SchemaError     < BaseError; end
  end
end
