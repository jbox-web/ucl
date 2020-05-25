# frozen_string_literal: true

module UCL
  class Decoder


    def self.decode(string)
      object = UCL::Parser.parse(string)
      convert_ucl_object(object)
    end


    private


    def self.convert_ucl_object(object)
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
    def self.convert_ucl_object_direct(object)
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


    def self.iter_ucl_object(object)
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
