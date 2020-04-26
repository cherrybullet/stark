module Stark
  module Expr
    class Binary
      def initialize(left, operator, right)
        @left, @operator, @right = left, operator, right
      end

      def accept(visitor)
        visitor.visitBinaryExpr(self)
      end
    end

    class Assign
      def initialize(name, value)
        @name, @value = name, value
      end

      def accept(visitor)
        visitor.visitAssignExpr(self)
      end
    end

    class Call
      def initialize(callee, paren, args)
        @callee, @paren, @args = callee, paren, args
      end

      def accept(visitor)
        visitor.visitCallExpr(self)
      end
    end

    class Get
      def initialize(object, name)
        @object, @name = object, name
      end

      def accept(visitor)
        visitor.visitGetExpr(self)
      end
    end

    class Grouping
      def initialize(expression)
        @expression = expression
      end

      def accept(visitor)
        visitor.visitGroupingExpr(self)
      end
    end

    class Literal
      def initialize(value)
        @value = value
      end

      def accept(visitor)
        visitor.visitLiteralExpr(self)
      end
    end

    class Logical
      def initialize(left, operator, right)
        @left, @operator, @right = left, operator, right
      end

      def accept(visitor)
        visitor.visitLogicalExpr(self)
      end
    end

    class Set
      def initialize(object, name, value)
        @object, @name, @value = object, name, value
      end

      def accept(visitor)
        visitor.visitSetExpr(self)
      end
    end

    class Super
      def initialize(keyword, method)
        @keyword, @method = keyword, method
      end

      def accept(visitor)
        visitor.visitSuperExpr(self)
      end
    end

    class This
      def initialize(keyword)
        @keyword = keyword
      end

      def accept(visitor)
        visitor.visitThisExpr(self)
      end
    end

    class Unary
      def initialize(operator, right)
        @operator, @right = operator, right
      end

      def accept(visitor)
        visitor.visitUnaryExpr(self)
      end
    end

    class Variable
      def initialize(name)
        @name = name
      end

      def accept(visitor)
        visitor.visitVariableExpr(self)
      end
    end
  end
end
