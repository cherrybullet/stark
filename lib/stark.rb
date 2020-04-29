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
end
