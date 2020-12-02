require 'spec_helper'

RSpec.describe UCL::Validator do

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
        expect(described_class.validate(schema, string)).to be true
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
          described_class.validate(schema, string)
        }.to raise_error(UCL::Error::SchemaError)
      end
    end
  end
end
