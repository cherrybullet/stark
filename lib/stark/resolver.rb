module Stark
  class Resolver
    module FunctionType
      FUNCTION = 1
      NONE = 0
    end

    attr_reader :scopes
    attr_reader :interpreter
    attr_reader :current_function

    def initialize(interpreter)
      @current_function = FunctionType::NONE
      @interpreter = interpreter
      @scopes = []
    end

    def visitBlockStmt(stmt)
      begin_scope
      resolve(stmt.statements)
      end_scope
      nil
    end

    def visitVarStmt(stmt)
      declare(stmt.name)
      if stmt.initializer
        resolve_expr(stmt.initializer)
      end
      define(stmt.name)
      nil
    end

    def visitCallExpr(expr)
      resolve_expr(expr.callee)
      expr.args.each do |argument|
        resolve_expr(argument)
      end
      nil
    end

    def visitPrintStmt(stmt)
      resolve_expr(stmt.expression)
      nil
    end

    def visitIfStmt(stmt)
      resolve_expr(stmt.condition)
      resolve_expr(stmt.then_branch)
      if stmt.else_branch
        resolve_expr(stmt.else_branch)
      end
      nil
    end

    def visitWhileStmt(stmt)
      resolve_expr(stmt.condition)
      resolve_expr(stmt.body)
      nil
    end

    def visitReturnStmt(stmt)
      if @current_function === FunctionType::NONE
        puts "<#{stmt.keyword}> Cannot return from top-level code."
      end

      if stmt.value
        resolve_expr(stmt.value)
      end
      nil
    end

    def visitExpressionStmt(stmt)
      resolve_expr(stmt.expression)
      nil
    end

    def visitFunctionStmt(stmt)
      declare(stmt.name)
      define(stmt.name)
      resolve_function(stmt, FunctionType::FUNCTION)
      nil
    end

    def visitVariableExpr(expr)
      if (@scopes[0] && (@scopes.first[expr.name.lexeme] == false))
        puts "<#{expr.name}> Cannot read local variable in its own initializer."
      end
      resolve_local(expr, expr.name)
      nil
    end

    def visitAssignExpr(expr)
      resolve_expr(expr.value)
      resolve_local(expr, expr.name)
      nil
    end

    def visitLogicalExpr(expr)
      resolve_expr(expr.left)
      resolve_expr(expr.right)
      nil
    end

    def visitBinaryExpr(expr)
      resolve_expr(expr.left)
      resolve_expr(expr.right)
      nil
    end

    def visitUnaryExpr(expr)
      resolve_expr(expr.right)
      nil
    end

    def visitGroupingExpr(expr)
      resolve_expr(expr.expression)
      nil
    end

    def visitLiteralExpr(expr)
    end

    def resolve_function(function, type)
      _enclosing_function = @current_function
      @current_function = type
      begin_scope
      function.params.each do |param|
        declare(param)
        define(param)
      end
      resolve(function.body)
      end_scope
      @current_function = _enclosing_function
    end

    def resolve_local(expr, name)
      _size = @scope.size
      (_size - 1).downto(0).to_a.each do |i|
        if @scopes[i].has_key?(name.lexeme)
          @interpreter.resolve(expr, @scopes.size - 1 - i)
          return nil
        end
      end
    end

    def begin_scope
      @scopes << {}
    end

    def end_scope
      @scopes.pop
    end

    def declare(name)
      return nil if @scopes.first.nil?
      _scope = @scopes.first
      if _scope.has_key?(name.lexeme)
        puts "<#{name}> Variable with this name already declared in this scope."
      end
      _scope[name.lexeme] = false
    end

    def define(name)
      return nil if @scopes.first.nil?
      @scopes.first[name.lexeme] = true
    end

    def resolve(statements)
      statements.each do |statement|
        resolve_stmt(statement)
      end
    end

    def resolve_stmt(stmt)
      stmt.accept(self)
    end

    def resolve_expr(expr)
      expr.accept(self)
    end
  end
end
