module Stark
  class Token
    include Types

    attr_reader :type
    attr_reader :lexeme
    attr_reader :literal
    attr_reader :line

    def initialize(type:, lexeme:, literal:, line:)
      @type, @lexeme, @literal, @line = type, lexeme, literal, line
    end

    def to_s
      "<#{@type}> #{lexeme}"
    end
  end
end
