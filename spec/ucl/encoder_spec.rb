require 'spec_helper'

RSpec.describe UCL::Encoder do

  let(:encoder) { described_class.new }

  let(:input_object) do
    {
      'string'  => 'bar',
      'true'    => true,
      'false'   => false,
      'nil'     => nil,
      'integer' => 1864,
      'double'  => 23.42,
      'time'    => 10.seconds,
      'array'   => [
        'foo',
        true,
        false,
        nil,
        1864,
        23.42,
        10.seconds
      ],
      'hash' => {
        'foo' => 'bar',
        'bar' => 'baz',
        'baz' => 'foo'
      },
      'array_of_array' => [
        ["foo", "bar"],
        ["bar", "baz"]
      ],
      'section' => {
        'foo' => {
          'key' => 'value'
        },
        'bar' => {
          'key' => 'value',
        },
        'baz' => {
          'foo' => {
            'key' => 'value'
          }
        },
      },
    }
  end


  describe '#encode' do
    context 'when emit_type is config' do
      let(:output_ucl_conf) { File.read(get_fixture_path('output_ucl.conf')) }

      it 'should encode UCL conf' do
        expect(encoder.encode(input_object)).to eq(output_ucl_conf)
      end
    end

    context 'when emit_type is yaml' do
      let(:output_ucl_conf) { File.read(get_fixture_path('output_ucl.yml')) }

      it 'should encode UCL conf as yaml' do
        expect(encoder.encode(input_object, 'yaml')).to eq(output_ucl_conf.chomp)
      end
    end

    context 'when emit_type is json' do
      let(:output_ucl_conf) { File.read(get_fixture_path('output_ucl.json')) }

      it 'should encode UCL conf as json' do
        expect(encoder.encode(input_object, 'json')).to eq(output_ucl_conf.chomp)
      end
    end

    context 'when emit_type is json_compact' do
      let(:output_ucl_conf) { File.read(get_fixture_path('output_ucl.json.min')) }

      it 'should encode UCL conf as json_compact' do
        expect(encoder.encode(input_object, 'json_compact')).to eq(output_ucl_conf.chomp)
      end
    end

    context 'when key object is not serializable' do
      let(:input_object) do
        { Object.new => 'foo' }
      end

      it 'raises an error' do
        expect {
          encoder.encode(input_object)
        }.to raise_error(UCL::Error::TypeError)
      end
    end

    context 'when value object is not serializable' do
      let(:input_object) do
        { 'foo' => Object.new }
      end

      it 'raises an error' do
        expect {
          encoder.encode(input_object)
        }.to raise_error(UCL::Error::TypeError)
      end
    end
  end
end
