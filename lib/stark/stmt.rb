module Stark
  module Stmt
    class Var
      attr_reader :name
      attr_reader :initializer

      def initialize(name, initializer)
        @name, @initializer = name, initializer
      end

      def accept(visitor)
        visitor.visitVarStmt(self)
      end
    end

    class Block
      attr_reader :statements

      def initialize(statements)
        @statements = statements
      end

      def accept(visitor)
        visitor.visitBlockStmt(self)
      end
    end

    class If
      attr_reader :condition
      attr_reader :then_branch
      attr_reader :else_branch

      def initialize(condition, then_branch, else_branch)
        @condition, @then_branch, @else_branch = condition, then_branch, else_branch
      end

      def accept(visitor)
        visitor.visitIfStmt(self)
      end
    end

    class While
      attr_reader :condition
      attr_reader :body

      def initialize(condition, body)
        @condition, @body = condition, body
      end

      def accept(visitor)
        visitor.visitWhileStmt(self)
      end
    end

    class Print
      attr_reader :expression

      def initialize(expression)
        @expression = expression
      end

      def accept(visitor)
        visitor.visitPrintStmt(self)
      end
    end

    class Expression
      attr_reader :expression

      def initialize(expression)
        @expression = expression
      end

      def accept(visitor)
        visitor.visitExpressionStmt(self)
      end
    end
  end
end
