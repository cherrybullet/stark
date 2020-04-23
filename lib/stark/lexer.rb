module Stark
  class Lexer
    def initialize
      @line, @current = 1, 0
      @tokens, @keywords = [], {
        # @start    = 0
        # @current  = 0
        # break import
        # in is static
        # "then", "unless",
        # "or", "is", "isnt", "not",
        # "new", "return",
        # "try", "catch", "finally", "throw",
        # "break", "continue",
        # "for", "in", "while",
        # "switch", "when",
        # "super", "extends",
        # keywords.put("and",    AND);
        # keywords.put("class",  CLASS);
        # keywords.put("else",   ELSE);
        # keywords.put("false",  FALSE);
        # keywords.put("for",    FOR);
        # keywords.put("fun",    FUN);
        # keywords.put("if",     IF);
        # keywords.put("nil",    NIL);
        # keywords.put("or",     OR);
        # keywords.put("print",  PRINT);
        # keywords.put("return", RETURN);
        # keywords.put("super",  SUPER);
        # keywords.put("this",   THIS);
        # keywords.put("true",   TRUE);
        # keywords.put("var",    VAR);
        # keywords.put("while",  WHILE);
      }
    end

    def tokenize(code)
      @code = code.chomp
    end

    private

    def add_token(type, lexeme, literal)
      @tokens << Token.new(type, lexeme, literal, @line)
    end

    def scan_token
    end
  end
end

# def Ripper.tokenize(src, filename = '-', lineno = 1)
#   Lexer.new(src, filename, lineno).tokenize
# private void addToken(TokenType type) {
#   addToken(type, null);|
# }
#
# private void addToken(TokenType type, Object literal) {
#   String text = source.substring(start, current);
#   tokens.add(new Token(type, text, literal, line));
# }
# l = Lexer.new.(code)|(type:, lexeme:, literal:, line:)
# add_token
# next_token
# extract_next_token
