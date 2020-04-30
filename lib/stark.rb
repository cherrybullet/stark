require 'stark/ast/printer'
require 'stark/token/types'
require 'stark/token'
require 'stark/lexer'
require 'stark/expr'
require 'stark/parser'
require 'stark/version'

module Stark
  module_function

  def run(code)
    tokens = Stark::Lexer.new.tokenize(code)
    tokens.map { |t| puts [t.type, t.lexeme, t.literal].inspect }
  end

  def run_file(path)
    run(Pathname(path).read)
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
