module Stark
  class Token
    include Types

    attr_reader :type
    attr_reader :lexeme
    attr_reader :literal
    attr_reader :lineno

    def initialize(type:, lexeme:, literal:, lineno:)
      @type, @lexeme, @literal, @line = type, lexeme, literal, lineno
    end

    def to_s
      "<#{@type}> #{lexeme}"
    end
  end
end
