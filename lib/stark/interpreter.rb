module Stark
  class Interpreter
    attr_reader :globals
    attr_reader :environment

    def initialize
      @globals = Environment.new
      @environment = @globals

      # globals.define("clock", new LoxCallable() {
      #   public int arity() { return 0; }
      #
      #   public Object call(Interpreter interpreter,
      #                      List<Object> arguments) {
      #     return (double)System.currentTimeMillis() / 1000.0;
      #   }
      #
      #   public String toString() { return "<native fn>"; }
      # })
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

    def visitReturnStmt(stmt)
      _value = nil
      if stmt.value
        _value = evaluate(stmt.value)
      else
        puts 'throw Return.new(value)'
      end
      raise ReturnSkip.new(_value)
    end

    def visitFunctionStmt(stmt)
      _function = Function.new(stmt)
      @environment.define_var(stmt.name.lexeme, _function)
      nil
    end

    def visitExpressionStmt(stmt)
      evaluate(stmt.expression)
      nil
    end

    def visitVariableExpr(expr)
      @environment.get_var(expr.name)
    end

    def visitAssignExpr(expr)
      _value = evaluate(expr.value)
      @environment.assign(expr.name, _value)
      _value
    end

    def visitBlockStmt(stmt)
      executeBlock(stmt.statements, Environment.new(@environment))
      nil
    end

    def visitIfStmt(stmt)
      if truthy?(evaluate(stmt.condition))
        execute(stmt.then_branch)
      elsif stmt.else_branch
        execute(stmt.else_branch)
      else
      end
      nil
    end

    def visitWhileStmt(stmt)
      while truthy?(evaluate(stmt.condition))
        execute(stmt.body)
      end
      nil
    end

    def visitCallExpr(expr)
      _callee = evaluate(expr.callee)
      _arguments = []

      expr.args.each do |argument|
        _arguments << evaluate(argument)
      end

      unless _callee.is_a?(Function)
        puts '<expr.paren> Can only call functions and classes.'
      end

      _function = _callee
      unless _arguments.size === _function.arity
        puts '<expr.paren> Expected function.arity() arguments but got arguments.size().'
      end
      _function.call(self, _arguments)
    end

    def visitLogicalExpr(expr)
      _left = evaluate(expr.left)

      if expr.operator.type === Token::OR
        if truthy?(_left)
          return _left
        end
      else
        unless truthy?(_left)
          return _left
        end
      end

      evaluate(expr.right)
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

    def executeBlock(statements, environment)
      _previous = @environment
      begin
        @environment = environment
        statements.each do |statement|
          execute(statement)
        end
      ensure
        @environment = _previous
      end
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
