require 'spec_helper'

RSpec.describe UCL::Decoder do

  let(:decoder) { described_class }

  let(:input_ucl_conf) { File.read(get_fixture_path('input_ucl.conf')) }

  let(:output_object) do
    {
      'string'  => 'bar',
      'string2' => 'baz',
      'true'    => true,
      'false'   => false,
      'nil'     => nil,
      'integer' => 1864,
      'double'  => 23.42,
      'time'    => '10s',
      'array'   => [
        'foo',
        true,
        false,
        nil,
        1864,
        23.42,
        '10s'
      ],
      'hash' => {
        'foo' => 'bar',
        'bar' => 'baz',
        'baz' => 'foo'
      },
      'array_of_array' => [
        ['foo', 'bar'],
        ['bar', 'baz']
      ],
      'auto_array' => {
        'key' => ['foo', 'bar', 'baz']
      },
      'section' => [
        {
          'foo' => {
            'key' => 'value'
          },
        },
        {
          'bar' => {
            'key' => 'value',
          },
        },
        {
          'baz' => {
            'foo' => {
              'key' => 'value'
            }
          },
        },
      ],
      'subsection' => {
        'host' => [
          {
            'host' => 'hostname',
            'port' => 900,
          },
          {
            'host' => 'hostname',
            'port' => 901,
          }
        ]
      }
    }
  end


  describe '.decode' do
    it 'should decode UCL conf' do
      expect(decoder.decode(input_ucl_conf)).to eq(output_object)
    end
  end
end
