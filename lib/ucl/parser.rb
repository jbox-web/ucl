# frozen_string_literal: true

module UCL
  class Parser

    class << self

      def parse(string)
        parser = new
        parser.parse(string)
      end

    end


    def initialize
      @parser = UCL::Wrapper.new(UCL::Wrapper::ParserFlags[:UCL_PARSER_NO_TIME] | UCL::Wrapper::ParserFlags[:UCL_PARSER_NO_IMPLICIT_ARRAYS])
    end


    def parse(string)
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
      UCL::Wrapper.get_object(@parser)
    end

  end
end
