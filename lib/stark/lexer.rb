module Stark
  class Lexer
    def initialize
      add_keywords
      @tokens = []
    end

    private

    def add_token(type, literal=nil)
      @tokens = Token.new(type: type, lexeme: lexeme, literal: literal, line: @line)
    end

    def add_keywords
      @keywords = {
      }
    end
  end
end

# private void addToken(TokenType type) {
#   addToken(type, null);
# }
#
# private void addToken(TokenType type, Object literal) {
#   String text = source.substring(start, current);
#   tokens.add(new Token(type, text, literal, line));
# }
# l = Lexer.new.tokenize(code)|(type:, lexeme:, literal:, line:)
# add_token
# next_token
# extract_next_token
