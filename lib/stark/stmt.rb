module Stark
  module Stmt
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
