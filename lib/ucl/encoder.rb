# frozen_string_literal: true

module UCL
  class Encoder

    EMITTERS = {
      'json'         => UCL::Wrapper::Emitters[:UCL_EMIT_JSON],
      'json_compact' => UCL::Wrapper::Emitters[:UCL_EMIT_JSON_COMPACT],
      'config'       => UCL::Wrapper::Emitters[:UCL_EMIT_CONFIG],
      'yaml'         => UCL::Wrapper::Emitters[:UCL_EMIT_YAML],
      'msgpack'      => UCL::Wrapper::Emitters[:UCL_EMIT_MSGPACK],
      'max'          => UCL::Wrapper::Emitters[:UCL_EMIT_MAX]
    }.freeze

    DEFAULT_EMITTER = 'config'


    def self.encode(object, emit_type = DEFAULT_EMITTER)
      emit_type  = EMITTERS[emit_type]
      ucl_object = to_ucl_object(object)
      UCL::Wrapper.object_emit(ucl_object, emit_type)
    end


    private


    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
    def self.to_ucl_object(object)
      case object.class.name
      when 'Array'
        array = UCL::Wrapper.object_typed_new(UCL::Wrapper::Types[:UCL_ARRAY])
        object.each do |item|
          UCL::Wrapper.array_append(array, to_ucl_object(item))
        end
        array
      when 'Hash'
        hash = UCL::Wrapper.object_typed_new(UCL::Wrapper::Types[:UCL_OBJECT])
        object.each do |key, value|
          raise UCL::Error::TypeError, "UCL only supports string keys: #{key}" unless key.is_a?(String)

          UCL::Wrapper.object_replace_key(hash, to_ucl_object(value), key.encode('utf-8'), 0, true)
        end
        hash
      when 'String'
        UCL::Wrapper.object_from_string(object.encode('utf-8'))
      when 'TrueClass', 'FalseClass'
        UCL::Wrapper.object_from_bool(object)
      when 'Integer'
        UCL::Wrapper.object_from_int(object)
      when 'Float'
        UCL::Wrapper.object_from_double(object)
      when 'NilClass'
        UCL::Wrapper.object_typed_new(UCL::Wrapper::Types[:UCL_NULL])
      when 'ActiveSupport::Duration'
        UCL::Wrapper.object_from_double(object.to_i.to_f)
      else
        raise UCL::Error::TypeError, "#{object.class.name}##{object.inspect} is not UCL serializable"
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength

  end
end
