require 'spec_helper'

RSpec.describe UCL do

  describe '.load' do
    it 'can decode UCL data with .load' do
      expect(UCL.load('foo = bar')).to eq({ 'foo' => 'bar' })
    end

    it 'should be threadsafe' do
      threads = []
      (1..10).each do |i|
        threads << Thread.new do
          expect(UCL.load("foo = #{i}")).to eq({ 'foo' => i })
        end
      end

      threads.map(&:join)
    end
  end


  describe '.dump' do
    it 'can encode UCL data with .dump' do
      expect(UCL.dump({ 'foo' => 'bar' })).to eq("foo = \"bar\";\n")
    end

    it 'should be threadsafe' do
      threads = []
      (1..10).each do |i|
        threads << Thread.new do
          expect(UCL.dump({ 'foo' => i })).to eq("foo = #{i};\n")
        end
      end

      threads.map(&:join)
    end
  end

  describe '.validate' do
    context 'when input data are valid' do
      let(:schema) do
        '''
        {
          "type": "object",
          "properties": {
            "key": {
              "type": "string"
            }
          }
        }
        '''
      end

      let(:string) do
        '''
        {
          "key": "some string"
        }
        '''
      end

      it 'can validate object' do
        expect(UCL.validate(schema, string)).to be true
      end
    end

    context 'when input data are invalid' do
      let(:schema) do
        '''
        {
          "type": "object",
          "properties": {
            "key": {
              "type": "boolean"
            }
          }
        }
        '''
      end

      let(:string) do
        '''
        {
          "key": "some string"
        }
        '''
      end

      it 'can validate object' do
        expect {
          UCL.validate(schema, string)
        }.to raise_error(UCL::Error::SchemaError)
      end
    end
  end

  describe '.valid?' do
    context 'when input data are valid' do
      let(:schema) do
        '''
        {
          "type": "object",
          "properties": {
            "key": {
              "type": "string"
            }
          }
        }
        '''
      end

      let(:string) do
        '''
        {
          "key": "some string"
        }
        '''
      end

      it 'can validate object' do
        expect(UCL.valid?(schema, string)).to be true
      end
    end

    context 'when input data are invalid' do
      let(:schema) do
        '''
        {
          "type": "object",
          "properties": {
            "key": {
              "type": "boolean"
            }
          }
        }
        '''
      end

      let(:string) do
        '''
        {
          "key": "some string"
        }
        '''
      end

      it 'can validate object' do
        expect(UCL.valid?(schema, string)).to be false
      end
    end
  end
end
