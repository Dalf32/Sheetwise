require 'treetop'
require_relative '../../../lib/data/parsing/Tokens'
require_relative '../../../lib/data/parsing/Arithmetic'
require_relative '../../../lib/data/parsing/token_nodes'
require_relative '../../../lib/data/parsing/arithmetic_nodes'

describe ArithmeticParser do
  before :all do
    @parser = ArithmeticParser.new
  end

  let(:test_str) { '' }

  describe 'parses' do
    shared_examples_for 'arithmetic' do
      it 'arithmetic' do
        ast = @parser.parse(test_str)

        expect(ast).not_to be_nil, @parser.failure_reason
        expect(ast.extension_modules).to include ExpressionNode
        expect(ast.to_ruby).to eq test_str #Arithmetic gets output as-is
      end
    end

    context 'simple expressions' do
      let(:test_str){ '2 + 4' }

      it_behaves_like 'arithmetic'
    end

    context 'simple expressions with identifiers' do
      let(:test_str){ 'bar ** 2.2' }

      it_behaves_like 'arithmetic'
    end

    context 'nested expressions' do
      let(:test_str){ '(17.4 - 3) % 2' }

      it_behaves_like 'arithmetic'
    end

    context 'nested expressions with identifiers' do
      let(:test_str){ '(17258694 * foo) + bar' }

      it_behaves_like 'arithmetic'
    end
  end
end