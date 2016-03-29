require 'treetop'
require_relative '../../../lib/data/parsing/Tokens'
require_relative '../../../lib/data/parsing/Arithmetic'
require_relative '../../../lib/data/parsing/BooleanLogic'
require_relative '../../../lib/data/parsing/token_nodes'
require_relative '../../../lib/data/parsing/arithmetic_nodes'
require_relative '../../../lib/data/parsing/boolean_logic_nodes'

describe BooleanLogicParser do
  before :all do
    @parser = BooleanLogicParser.new
  end

  let(:test_str){ '' }

  describe 'parses' do
    shared_examples_for 'boolean logic' do
      it 'boolean logic' do
        ast = @parser.parse(test_str)

        expect(ast).not_to be_nil, @parser.failure_reason
        expect(ast.extension_modules).to include BooleanExpressionNode
        expect(ast.to_ruby).to eq test_str #Boolean Logic gets output as-is
      end
    end

    context 'simple unary boolean expressions' do
      let(:test_str){ '!true' }

      it_behaves_like 'boolean logic'
    end


    context 'simple unary boolean expressions with identifiers' do
      let(:test_str){ '!bar' }

      it_behaves_like 'boolean logic'
    end

    context 'simple binary boolean expressions' do
      let(:test_str){ 'true && true' }

      it_behaves_like 'boolean logic'
    end

    context 'simple binary boolean expressions with identifiers' do
      let(:test_str){ 'foo == false' }

      it_behaves_like 'boolean logic'
    end

    context 'unary nested boolean expressions' do
      let(:test_str){ '!(bar != true)' }

      it_behaves_like 'boolean logic'
    end

    context 'boolean nested boolean expressions' do
      let(:test_str){ '(bar || baz) && true' }

      it_behaves_like 'boolean logic'
    end

    context 'comparison expressions' do
      let(:test_str){ '7 > 4' }

      it_behaves_like 'boolean logic'
    end

    context 'comparison expressions with identifiers' do
      let(:test_str){ 'baz <= 97.3' }

      it_behaves_like 'boolean logic'
    end

    context 'comparison expressions with subexpressions' do
      let(:test_str){ '(47 * bar) <= 22.3' }

      it_behaves_like 'boolean logic'
    end

    context 'unary expressions with nested comparison expressions' do
      let(:test_str){ '!(-17 >= 6.2)' }

      it_behaves_like 'boolean logic'
    end

    context 'binary expressions with nested comparison expressions' do
      let(:test_str){ 'foo && (55 < bar)' }

      it_behaves_like 'boolean logic'
    end
  end
end