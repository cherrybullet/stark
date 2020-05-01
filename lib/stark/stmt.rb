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
