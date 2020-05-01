require 'stark/ast/printer'
require 'stark/token/types'
require 'stark/token'
require 'stark/lexer'
require 'stark/expr'
require 'stark/stmt'
require 'stark/environment'
require 'stark/interpreter'
require 'stark/parser'
require 'stark/version'

module Stark
  # static boolean hadError = false;
  # static boolean hadRuntimeError = false;

  class RuntimeError
    def initialize(token, message)
      @token, @message = token, message
    end
  end

  module_function

  def run(code)
    tokens = Lexer.new.tokenize(code)
    tokens.map { |t| puts [t.type, t.lexeme, t.literal].inspect }
  end

  def run_file(path)
    run(Pathname(path).read)
  end

  def print_tree(code)
    puts JSON.pretty_generate([AST::Printer.new.print(Parser.new(Lexer.new.tokenize(code)).parse)])
  end

  def print_result(code)
    puts Interpreter.new.interpret(Parser.new(Lexer.new.tokenize(code)).parse)
  end

  def mock_ast
    expression = Expr::Binary.new(
      Expr::Unary.new(
        Token.new(type: Token::MINUS, lexeme: '-', literal: nil, line: 1),
        Expr::Literal.new(101)
      ),
      Token.new(type: Token::STAR, lexeme: '*', literal: nil, line: 1),
        Expr::Grouping.new(
        Expr::Literal.new(1.01)
      )
    )
  end

  def error(token, message)
    if token.type === Token::EOF
      puts "#{token.line}: at end, #{message}"
    else
      puts "#{token.line}: at end, `#{token.lexeme}`, #{message}"
    end
  end
end
