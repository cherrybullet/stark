module Stark
  class Interpreter
    def initialize
      @environment = Environment.new
    end

    def interpret(statements)
      statements.each do |statement|
        execute(statement)
      end
    end

    def visitVarStmt(stmt)
      _value = nil
      unless stmt.initializer.nil?
        _value = evaluate(stmt.initializer)
      end

      @environment.define_var(stmt.name.lexeme, _value)
      nil
    end

    def visitPrintStmt(stmt)
      _value = evaluate(stmt.expression)
      puts _value
    end

    def visitExpressionStmt(stmt)
      evaluate(stmt.expression)
      nil
    end

    def visitVariableExpr(expr)
      @environment.get_var(expr.name)
    end

    def visitBinaryExpr(expr)
      _left = evaluate(expr.left)
      _right = evaluate(expr.right)

      case expr.operator.type
      when Token::PLUS
        # Operands must be two numbers or two strings. | RuntimeError
        if _left.is_a?(String)
          _left.to_s + _right.to_s
        else
          _left.to_f + _right.to_f
        end
      when Token::MINUS then (_left.to_f - _right.to_f)
      when Token::STAR then (_left.to_f * _right.to_f)
      when Token::SLASH then (_left.to_f / _right.to_f)
      when Token::GREATER then (_left.to_f > _right.to_f)
      when Token::GREATER_EQUAL then (_left.to_f >= _right.to_f)
      when Token::LESS then (_left.to_f < _right.to_f)
      when Token::LESS_EQUAL then (_left.to_f <= _right.to_f)
      when Token::BANG_EQUAL then !equal?(_left, _right)
      when Token::EQUAL_EQUAL then equal?(_left, _right)
      else
      end
    end

    def visitUnaryExpr(expr)
      _right = evaluate(expr.right)

      case expr.operator.type
      when Token::MINUS then -(_right.to_f)
      when Token::BANG then !truthy?(_right)
      else
      end
    end

    def visitGroupingExpr(expr)
      evaluate(expr.expression)
    end

    def visitLiteralExpr(expr)
      expr.value
    end

    def checkNumberOperands(operator, left, right)
      # Operands must be numbers. | RuntimeError
    end

    def checkNumberOperand(operator, operand)
      # Operand must be a number.
    end

    def truthy?(object)
      return false if object.nil?
      return false if object.is_a?(FalseClass)
      return true
    end

    def equal?(a, b)
      return true if a.nil? and b.nil?
      return a.eql?(b)
    end

    def execute(stmt)
      stmt.accept(self)
    end

    def evaluate(expr)
      expr.accept(self)
    end
  end
end
