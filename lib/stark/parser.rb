module Stark
  class Parser
    def initialize(tokens)
      @tokens = tokens
      @current = 0
    end

    def parse(options={})
      _statements = []

      loop {
        break if at_end?
        _statements << declaration
      }

      _statements
    end

    private

    def declaration
      # synchronize?
      if match?(Token::VAR)
        var_declaration
      else
        statement
      end
    end

    def statement
      if match?(Token::IF)
        return if_statement
      end

      if match?(Token::PRINT)
        print_statement
      elsif match?(Token::LEFT_BRACE)
        Stmt::Block.new(block)
      else
        expression_statement
      end
    end

    def if_statement
      consume(Token::LEFT_PAREN, 'Expect `(` after `if`.')
      _condition = expression

      consume(Token::RIGHT_PAREN, 'Expect `)` after if condition.')
      _then_branch = statement
      _else_branch = nil

      if match?(Token::ELSE)
        _else_branch = statement
      end

      Stmt::If.new(_condition, _then_branch, _else_branch)
    end

    def block
      _statements = []

      loop {
        break if check?(Token::RIGHT_BRACE)
        break if at_end?
        _statements << declaration
      }

      consume(Token::RIGHT_BRACE, 'Expect `}` after block.')

      _statements
    end

    def var_declaration
      _name = consume(Token::IDENTIFIER, 'Expect variable name.')
      _initializer = nil

      if match?(Token::EQUAL)
        _initializer = expression
      end

      consume(Token::SEMICOLON, 'Expect `;` after variable declaration.')

      Stmt::Var.new(_name, _initializer)
    end

    def print_statement
      _value = expression
      consume(Token::SEMICOLON, 'Expect `;` after value.')
      Stmt::Print.new(_value)
    end

    def expression_statement
      _expr = expression
      consume(Token::SEMICOLON, 'Expect `;` after expression.')
      Stmt::Expression.new(_expr)
    end

    def expression
      assignment
    end

    def assignment
      _expr = equality

      if match?(Token::EQUAL)
        _equals = previous
        _value = assignment

        if _expr.is_a?(Expr::Variable)
          _name = _expr.name
          return Expr::Assign.new(_name, _value)
        end

        puts "#{_equals.inspect} Invalid assignment target."
      end

      _expr
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

      if match?(Token::IDENTIFIER)
        return Expr::Variable.new(previous)
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
      # Stark.error(*args)
      # ParseError.new
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
