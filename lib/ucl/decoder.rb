# frozen_string_literal: true

module UCL
  class Decoder

    def initialize(parser = UCL::Wrapper.new(0))
      @parser = parser
    end


    def decode(string)
      load_string(string.encode('utf-8'))
      check_error
      load_result
    end


    private


    def load_string(string)
      UCL::Wrapper.add_string(@parser, string, string.length)
    end


    def check_error
      error = UCL::Wrapper.get_error(@parser)
      raise UCL::Error::DecoderError, error unless error.nil?
    end


    def load_result
      object = UCL::Wrapper.get_object(@parser)
      convert_ucl_object(object)
    end


    def convert_ucl_object(object)
      result = convert_ucl_object_direct(object)

      if !object.next.null? && object.type != UCL::Wrapper::Types[:UCL_OBJECT]
        result = [result]

        loop do
          object = object.next
          break if object.null?

          result << convert_ucl_object_direct(object)
        end
      end

      result
    end


    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
    def convert_ucl_object_direct(object)
      case object.type
      when UCL::Wrapper::Types[:UCL_OBJECT]
        hash = {}
        iter_ucl_object(object) do |child|
          key = UCL::Wrapper.object_key(child)
          value = convert_ucl_object(child)
          hash[key] = value
        end
        hash

      when UCL::Wrapper::Types[:UCL_ARRAY]
        array = []
        iter_ucl_object(object) do |child|
          array << convert_ucl_object(child)
        end
        array

      when UCL::Wrapper::Types[:UCL_INT]
        UCL::Wrapper.object_to_int(object)

      when UCL::Wrapper::Types[:UCL_FLOAT], UCL::Wrapper::Types[:UCL_TIME]
        UCL::Wrapper.object_to_double(object)

      when UCL::Wrapper::Types[:UCL_STRING]
        UCL::Wrapper.object_to_string(object)

      when UCL::Wrapper::Types[:UCL_BOOLEAN]
        UCL::Wrapper.object_to_boolean(object)

      when UCL::Wrapper::Types[:UCL_NULL]
        nil

      else
        raise UCL::Error::ConversionError, "Unsupported object type: #{object.type}"
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength


    def iter_ucl_object(object)
      iterator = UCL::Wrapper.object_iterate_new(object)
      loop do
        ptr = UCL::Wrapper.object_iterate_safe(iterator, true)
        break if ptr.null?

        yield ptr if block_given?
      end
    ensure
      UCL::Wrapper.object_iterate_free(iterator)
    end

  end
end
