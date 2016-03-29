require 'treetop'
require_relative '../../../lib/data/parsing/Tokens'
require_relative '../../../lib/data/parsing/token_nodes'

describe TokensParser do
  before :all do
    @parser = TokensParser.new
  end

  let(:test_str){ '' }
  let(:node_type){ LiteralNode }

  describe 'parses' do
    shared_examples_for 'tokens' do
      it 'tokens' do
        ast = @parser.parse(test_str)

        expect(ast).not_to be_nil, @parser.failure_reason
        expect(ast.extension_modules).to include node_type
        expect(ast.to_ruby).to eq test_str #Arithmetic gets output as-is
      end
    end

    context 'positive integer values' do
      let(:test_str){ '17' }

      it_behaves_like 'tokens'
    end

    context 'negative integer values' do
      let(:test_str){ '-3' }

      it_behaves_like 'tokens'
    end

    context 'positive floating point numbers' do
      let(:test_str){ '228.45' }

      it_behaves_like 'tokens'
    end

    context 'negative floating point numbers' do
      let(:test_str){ '-0.6' }

      it_behaves_like 'tokens'
    end

    context 'double-quoted strings' do
      let(:test_str){ '"This is a string."' }

      it_behaves_like 'tokens'
    end

    context 'single-quoted strings' do
      let(:test_str){ "'This is another string.'" }

      it_behaves_like 'tokens'
    end

    context 'true' do
      let(:test_str){ 'true' }

      it_behaves_like 'tokens'
    end

    context 'false' do
      let(:test_str){ 'false' }

      it_behaves_like 'tokens'
    end

    context 'identifiers' do
      let(:test_str){ 'foo' }
      let(:node_type){ IdentifierNode }

      it_behaves_like 'tokens'
    end

    context 'whitespace' do
      let(:test_str){ "  \t " }
      let(:node_type){ WhitespaceNode }

      it_behaves_like 'tokens'
    end

    context 'newlines' do
      let(:test_str){ "\n\r\n" }
      let(:node_type){ WhitespaceNode }

      it_behaves_like 'tokens'
    end
  end

  it 'disallows keywords as identifiers' do
    ast = @parser.parse('if')

    expect(ast).to be_nil, @parser.failure_reason
  end
end