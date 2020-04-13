require 'spec_helper'

RSpec.describe UCL do

  describe '.load' do
    it 'can decode UCL data with .load' do
      expect(UCL.load('foo = bar')).to eq({ 'foo' => 'bar' })
    end
  end


  describe '.dump' do
    it 'can encode UCL data with .dump' do
      expect(UCL.dump({ 'foo' => 'bar' })).to eq("foo = \"bar\";\n")
    end
  end

end
