module Stark
  class Resolver
    attr_reader :scopes
    attr_reader :interpreter

    def initialize(interpreter)
      @interpreter = interpreter
      @scopes = []
    end

    # private final Stack<Map<String, Boolean>> scopes = new Stack<>();
    #   +private FunctionType currentFunction = FunctionType.NONE;
    #
    #   Resolver(Interpreter interpreter) {
    # lox/Resolver.java, in class Resolver

    # private enum FunctionType {
    #     NONE,
    #     FUNCTION
    #   }
    # lox/Resolver.java, add after Resolver()

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
      if stmt.value
        resolve_expr(stmt.value)
      end
      nil
    end


    # public Void visitReturnStmt(Stmt.Return stmt) {
    #     if (currentFunction == FunctionType.NONE) {
    #       Lox.error(stmt.keyword, "Cannot return from top-level code.");
    #     }
    #
    #     if (stmt.value != null) {
    # lox/Resolver.java, in visitReturnStmt()

    def visitExpressionStmt(stmt)
      resolve_expr(stmt.expression)
      nil
    end

    def visitFunctionStmt(stmt)
      declare(stmt.name)
      define(stmt.name)
      resolve_function(stmt)
      nil
    end

    # define(stmt.name);
    #     +resolveFunction(stmt, FunctionType.FUNCTION);
    #     return null;
    # lox/Resolver.java, in visitFunctionStmt(), replace 1 line


    def visitVariableExpr(expr)
      # if (!scopes.isEmpty() &&
      #     scopes.peek().get(expr.name.lexeme) == Boolean.FALSE) {
      #   Lox.error(expr.name,
      #       "Cannot read local variable in its own initializer.");
      # }
      #
      # resolveLocal(expr, expr.name);
      # return null;
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

    def resolve_function(function)
      #   beginScope();
      #   for (Token param : function.params) {
      #     declare(param);
      #     define(param);
      #   }
      #   resolve(function.body);
      #   endScope();
    end

    # private void resolveFunction(
    #       Stmt.Function function, FunctionType type) {
    #     FunctionType enclosingFunction = currentFunction;
    #     currentFunction = type;
    #
    #     beginScope();
    # lox/Resolver.java, method resolveFunction(), replace 1 line

# endScope();
#     currentFunction = enclosingFunction;
#   }
# lox/Resolver.java, in resolveFunction()



    def resolve_local(expr, name)
      # for (int i = scopes.size() - 1; i >= 0; i--) {
      #   if (scopes.get(i).containsKey(name.lexeme)) {
      #     interpreter.resolve(expr, scopes.size() - 1 - i);
      #     return;
      #   }
      # }
      #
      # // Not found. Assume it is global.
    end

    def begin_scope
      # new HashMap<String, Boolean>()?
      @scopes << {}
    end

    def end_scope
      @scopes.pop
    end

    def declare(name)
      return nil if @scopes.first.nil?
      scope = @scopes.peek
      scope << {}
      # Map<String, Boolean> [] = scopes.peek();
      # scope.put(name.lexeme, false);
    end

    # Map<String, Boolean> scope = scopes.peek();
    #     if (scope.containsKey(name.lexeme)) {
    #       Lox.error(name,
    #           "Variable with this name already declared in this scope.");
    #     }
    #
    #     scope.put(name.lexeme, false);
    # lox/Resolver.java, in declare()




    def define(name)
      return nil if @scopes.first.nil?
      # scopes.peek().put(name.lexeme, true);
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
