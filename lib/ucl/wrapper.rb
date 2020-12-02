# frozen_string_literal: true

module UCL
  module Wrapper
    extend FFI::Library

    ffi_lib ['ucl', "#{__dir__}/libucl.so"]

    Types = enum %i[
      UCL_OBJECT
      UCL_ARRAY
      UCL_INT
      UCL_FLOAT
      UCL_STRING
      UCL_BOOLEAN
      UCL_TIME
      UCL_USERDATA
      UCL_NULL
    ]

    Emitters = enum %i[
      UCL_EMIT_JSON
      UCL_EMIT_JSON_COMPACT
      UCL_EMIT_CONFIG
      UCL_EMIT_YAML
      UCL_EMIT_MSGPACK
      UCL_EMIT_MAX
    ]

    SchemaErrorCode = enum %i[
      UCL_SCHEMA_OK
      UCL_SCHEMA_TYPE_MISMATCH
      UCL_SCHEMA_INVALID_SCHEMA
      UCL_SCHEMA_MISSING_PROPERTY
      UCL_SCHEMA_CONSTRAINT
      UCL_SCHEMA_MISSING_DEPENDENCY
      UCL_SCHEMA_EXTERNAL_REF_MISSING
      UCL_SCHEMA_EXTERNAL_REF_INVALID
      UCL_SCHEMA_INTERNAL_ERROR
      UCL_SCHEMA_UNKNOWN
    ]

    ParserFlags = enum [
      :UCL_PARSER_DEFAULT,            0,        # No special flags
      :UCL_PARSER_KEY_LOWERCASE,      (1 << 0), # Convert all keys to lower case
      :UCL_PARSER_ZEROCOPY,           (1 << 1), # Parse input in zero-copy mode if possible
      :UCL_PARSER_NO_TIME,            (1 << 2), # Do not parse time and treat time values as strings
      :UCL_PARSER_NO_IMPLICIT_ARRAYS, (1 << 3), # Create explicit arrays instead of implicit ones
      :UCL_PARSER_SAVE_COMMENTS,      (1 << 4), # Save comments in the parser context
      :UCL_PARSER_DISABLE_MACRO,      (1 << 5), # Treat macros as comments
      :UCL_PARSER_NO_FILEVARS,        (1 << 6), # Do not set file vars
    ]

    class Value < FFI::Union
      layout :iv, :int64,
             :sv, :char,
             :dv, :double,
             :av, :pointer,
             :ov, :pointer,
             :ud, :pointer
    end

    class UclObject < FFI::Struct
      layout :value,       Value,
             :key,         :char,
             :next,        UclObject.ptr,
             :prev,        UclObject.ptr,
             :keylen,      :uint32,
             :len,         :uint32,
             :ref,         :uint32,
             :flags,       :uint16,
             :type,        :uint16,
             :trash_stack, [:uchar, 2]

      def type
        self[:type]
      end

      def next
        self[:next]
      end

      def null?
        address.zero?
      end

      def address
        pointer.address
      end
    end

    class SchemaError < FFI::Struct
      layout :code, UCL::Wrapper::SchemaErrorCode,
             :msg, [:char, 128],
             :obj, UclObject

      def code
        self[:code]
      end

      def message
        self[:msg]
      end
    end


    attach_function :new,                 :ucl_parser_new,          [:int],                     :pointer
    attach_function :add_string,          :ucl_parser_add_string,   %i[pointer pointer size_t], :bool
    attach_function :get_error,           :ucl_parser_get_error,    [:pointer],                 :string
    attach_function :get_object,          :ucl_parser_get_object,   [:pointer],                 UclObject.by_ref

    attach_function :object_key,          :ucl_object_key,          [UclObject.by_ref], :string
    attach_function :object_to_int,       :ucl_object_toint,        [UclObject.by_ref], :int
    attach_function :object_to_double,    :ucl_object_todouble,     [UclObject.by_ref], :double
    attach_function :object_to_string,    :ucl_object_tostring,     [UclObject.by_ref], :string
    attach_function :object_to_boolean,   :ucl_object_toboolean,    [UclObject.by_ref], :bool

    attach_function :object_iterate_new,  :ucl_object_iterate_new,  [UclObject.by_ref], :pointer
    attach_function :object_iterate_safe, :ucl_object_iterate_safe, %i[pointer bool],   UclObject.by_ref
    attach_function :object_iterate_free, :ucl_object_iterate_free, [:pointer],         :void

    attach_function :object_emit,         :ucl_object_emit,         [UclObject.by_ref, :int], :string
    attach_function :object_validate,     :ucl_object_validate,     [UclObject.by_ref, UclObject.by_ref, SchemaError], :bool
    attach_function :array_append,        :ucl_array_append,        [UclObject.by_ref, UclObject.by_ref], :bool
    attach_function :object_replace_key,  :ucl_object_replace_key,  [UclObject.by_ref, UclObject.by_ref, :string, :size_t, :bool], :bool

    attach_function :object_typed_new,    :ucl_object_typed_new,    [:int],    UclObject.by_ref
    attach_function :object_from_int,     :ucl_object_fromint,      [:int],    UclObject.by_ref
    attach_function :object_from_bool,    :ucl_object_frombool,     [:bool],   UclObject.by_ref
    attach_function :object_from_double,  :ucl_object_fromdouble,   [:double], UclObject.by_ref
    attach_function :object_from_string,  :ucl_object_fromstring,   [:string], UclObject.by_ref
  end
end
