require 'treetop'
require_relative '../../../lib/data/parsing/Tokens'
require_relative '../../../lib/data/parsing/Arithmetic'
require_relative '../../../lib/data/parsing/BooleanLogic'
require_relative '../../../lib/data/parsing/SheetScript'
require_relative '../../../lib/data/parsing/token_nodes'
require_relative '../../../lib/data/parsing/arithmetic_nodes'
require_relative '../../../lib/data/parsing/boolean_logic_nodes'
require_relative '../../../lib/data/parsing/sheet_script_nodes'

describe SheetScriptParser do
  before :all do
    @parser = SheetScriptParser.new
  end

  subject(:ast) { @parser.parse(test_str) }
  let(:test_str){ '' }
  let(:result_str){ '' }
  let(:node_type){ ScriptNode }

  describe 'parses' do
    shared_examples_for 'sheet script' do
      it 'sheet script' do
        expect(ast).not_to be_nil, @parser.failure_reason
        expect(ast.extension_modules).to include(node_type), ast.inspect
        expect(ast.to_ruby).to eq(result_str), ast.inspect
      end
    end

    context 'single-line comments' do
      let(:test_str){ "#This is a single-line comment\n" }

      it_behaves_like 'sheet script'
      it { expect(ast.elements.first.extension_modules).to include CommentNode }
    end

    context 'multi-line comments' do
      let(:test_str){ <<CODE.strip
        /* This is a
         multi-line
         comment */
CODE
      }

      it_behaves_like 'sheet script'
      it { expect(ast.elements.first.extension_modules).to include CommentNode }
    end

    context 'empty, simple validators' do
      let(:test_str){ <<CODE.strip
        validate foo ->
        done
CODE
      }
      let(:result_str){ <<CODE.strip
        validate(foo) do
        done
CODE
      }

      it_behaves_like 'sheet script'
      it { expect(ast.elements.first.extension_modules).to include ValidatorNode }
    end

    context 'empty validators' do
      let(:test_str){ <<CODE.strip
        validate foo, bar with baz ->
        done
CODE
      }
      let(:result_str){ <<CODE.strip
        validate(foo, bar).with(baz) do
        done
CODE
      }

      it_behaves_like 'sheet script'
      it { expect(ast.elements.first.extension_modules).to include ValidatorNode }
    end

    context 'empty, simple calculators' do
      let(:test_str){ <<CODE.strip
        calculate foo ->
        done
CODE
      }
      let(:result_str){ <<CODE.strip
        calculate(foo) do
        done
CODE
      }

      it_behaves_like 'sheet script'
      it { expect(ast.elements.first.extension_modules).to include CalculatorNode }
    end

    context 'empty calculators' do
      let(:test_str){ <<CODE.strip
        calculate foo, bar with baz ->
        done
CODE
      }
      let(:result_str){ <<CODE.strip
        calculate(foo, bar).with(baz) do
        done
CODE
      }

      it_behaves_like 'sheet script'
      it { expect(ast.elements.first.extension_modules).to include CalculatorNode }
    end
  end
end