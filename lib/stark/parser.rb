module Stark
  class Parser
    def initialize(tokens)
      @tokens = tokens
      @current = 0
    end

    def parse(options={})
    end

    private

    def expression
      equality
    end

    def equality
      _expr = comparison

      while match?(Token::BANG_EQUAL, Token::EQUAL_EQUAL)
        _operator = previous
        _right = comparison
        _expr = Expr::Binary.new(_expr, _operator, _right)
      end

      _expr
    end

    def comparison
      _expr = addition

      while match?(Token::GREATER, Token:: GREATER_EQUAL, Token::LESS, Token::LESS_EQUAL)
        _operator = previous
        _right = addition
        _expr = Expr::Binary.new(_expr, _operator, _right)
      end

      _expr
    end

    def addition
      _expr = multiplication

      while match?(Token::MINUS, Token::PLUS)
        _operator = previous
        _right = multiplication
        _expr = Expr::Binary.new(_expr, _operator, _right)
      end

      _expr
    end

    def multiplication
      _expr = unary

      while match?(Token::SLASH, Token::STAR)
        _operator = previous
        _right = unary
        _expr = Expr::Binary.new(_expr, _operator, _right)
      end

      _expr
    end

    def unary
      if match?(Token::BANG, Token::MINUS)
        _operator = previous
        _right = unary
        Expr::Unary.new(_operator, _right)
      end

      primary
    end

    def primary
      return Expr::Literal.new(false) if match?(Token::FALSE)
      return Expr::Literal.new(true) if match?(Token::TRUE)
      return Expr::Literal.new(nil) if match?(Token::NIL)

      if match?(Token::NUMBER, Token::STRING)
        return Expr::Literal.new(previous.literal)
      end

      if match?(Token::LEFT_PAREN)
        _expr = expression
        consume(Token::RIGHT_PAREN, 'Expect `)` after expression.')
        return Expr::Grouping.new(_expr)
      end

      puts 'raise error(peek, message)'
    end

    def consume(type, message)
      if check?(type)
        advance
      else
        puts 'raise error(peek, message)'
      end
    end

    def error(token, message)
    end

    def synchronize
      advance

      loop {
        break if at_end?
        break if previous.type === Token::SEMICOLON

        case peek.type
        when Token::CLASS then break
        when Token::FUN then break
        when Token::VAR then break
        when Token::FOR then break
        when Token::IF then break
        when Token::WHILE then break
        when Token::PRINT then break
        when Token::RETURN then break
        else
          advance
        end
      }
    end

    def match?(*types)
      types.each do |type|
        if check?(type)
          advance
          return true
        end
      end

      return false
    end

    def check?(type)
      return false if at_end?
      peek.type === type
    end

    def advance
      unless at_end?
        @current += 1
      end

      previous
    end

    def peek
      @tokens[@current]
    end

    def previous
      @tokens[@current - 1]
    end

    def at_end?
      peek.type === Token::EOF
    end
  end
end
