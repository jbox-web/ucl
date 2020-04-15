# frozen_string_literal: true

module UCL
  module Wrapper
    extend FFI::Library

    ffi_lib ['ucl', "#{__dir__}/libucl.so"]

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
    attach_function :array_append,        :ucl_array_append,        [UclObject.by_ref, UclObject.by_ref], :bool
    attach_function :object_replace_key,  :ucl_object_replace_key,  [UclObject.by_ref, UclObject.by_ref, :string, :size_t, :bool], :bool

    attach_function :object_typed_new,    :ucl_object_typed_new,    [:int],    UclObject.by_ref
    attach_function :object_from_int,     :ucl_object_fromint,      [:int],    UclObject.by_ref
    attach_function :object_from_bool,    :ucl_object_frombool,     [:bool],   UclObject.by_ref
    attach_function :object_from_double,  :ucl_object_fromdouble,   [:double], UclObject.by_ref
    attach_function :object_from_string,  :ucl_object_fromstring,   [:string], UclObject.by_ref
  end
end
